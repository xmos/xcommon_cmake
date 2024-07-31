cmake_minimum_required(VERSION 3.21)

include_guard(GLOBAL)

set(XCOMMON_CMAKE_VER 1.3.0 CACHE INTERNAL "Version of XCommon CMake")

macro(print_xcommon_cmake_version)
    message(VERBOSE "XCommon CMake version v${XCOMMON_CMAKE_VER}")
endmacro()

option(BUILD_NATIVE "Build applications/libraries for the native CPU instead of the xcore architecture")
option(DEPS_CLONE_SHALLOW "Perform a shallow git clone (--depth=1) for all dependencies")

# Set up compiler
if(NOT BUILD_NATIVE AND NOT DEFINED ${CMAKE_TOOLCHAIN_FILE})
    include($ENV{XMOS_CMAKE_PATH}/xcore_xs.cmake)
endif()

if(PROJECT_SOURCE_DIR)
    message(FATAL_ERROR "xcommon.cmake must be included before a project definition")
endif()

# If Unix Makefiles are being generated, but a version of make is not present, set xmake as the
# make program in the variable cache as it will definitely be available.
if(CMAKE_GENERATOR STREQUAL "Unix Makefiles" AND NOT DEFINED CMAKE_MAKE_PROGRAM)
    set(CMAKE_MAKE_PROGRAM xmake CACHE STRING "")
endif()

# Default architecture of static library archives to build if not specified
set(DEFAULT_STATICLIB_ARCH xs3a)

include(FetchContent)

enable_language(CXX C ASM)

# Define XMOS-specific target properties
define_property(TARGET PROPERTY OPTIONAL_HEADERS BRIEF_DOCS "Contains list of optional headers." FULL_DOCS "Contains a list of optional headers.  The application level should search through all app includes and define D__[header]_h_exists__ for each header that is in both the app and optional headers.")

# Global properties to record hosts that can/cannot be accessed via an SSH key to avoid repeatedly checking
set_property(GLOBAL PROPERTY SSH_HOST_SUCCESS "")
set_property(GLOBAL PROPERTY SSH_HOST_FAILURE "")

set(MANIFEST_OUT ${CMAKE_BINARY_DIR}/manifest.txt)
if(FULL_MANIFEST)
    set(DEP_REQ_HEADER "                                  | Depends_on")
    set(DEP_REQ_DIVIDER                                  "+------------------------------")
endif()
set(MANIFEST_HEADER
        "Name                    | Location                                        | Branch/tag             | Changeset${DEP_REQ_HEADER}\n"
        "------------------------+-------------------------------------------------+------------------------+--------------------------------------------${DEP_REQ_DIVIDER}\n")

function (GET_ALL_VARS_STARTING_WITH _prefix _varResult)
    get_cmake_property(_vars VARIABLES)
    string (REGEX MATCHALL "(^|;)${_prefix}[A-Za-z0-9_\\.]*" _matchedVars "${_vars}")
    set (${_varResult} ${_matchedVars} PARENT_SCOPE)
endfunction()

macro(add_file_flags prefix file_srcs)
    set(FLAG_FILES "")
    foreach(flags ${${prefix}_COMPILER_FLAGS_VARS})
        string(REPLACE "${prefix}_COMPILER_FLAGS_" "" flags ${flags})

        # Only consider "file" flags; ignore "config" flags
        if(flags MATCHES "\\.")
            list(APPEND FLAG_FILES ${flags})
        endif()
    endforeach()

    foreach(SRC_FILE_PATH ${file_srcs})
        # Over-ride file flags if APP/LIB_COMPILER_FLAGS_<source_file> is set
        get_filename_component(SRC_FILE ${SRC_FILE_PATH} NAME)
        foreach(FLAG_FILE ${FLAG_FILES})
            string(COMPARE EQUAL ${FLAG_FILE} ${SRC_FILE} _cmp)
            if(_cmp)
                set(flags ${${prefix}_COMPILER_FLAGS_${FLAG_FILE}})
                foreach(target ${APP_BUILD_TARGETS})
                    set_source_files_properties(${SRC_FILE_PATH}
                                                TARGET_DIRECTORY ${target}
                                                PROPERTIES COMPILE_OPTIONS "${flags}")
                endforeach()
            endif()
        endforeach()
    endforeach()
endmacro()

# Remove src files from ALL_SRCS if they are for a different config and return source
# file list in RET_CONFIG_SRCS
function(remove_srcs ALL_APP_CONFIGS APP_CONFIG ALL_SRCS RET_CONFIG_SRCS)
    set(CONFIG_SRCS ${ALL_SRCS})

    foreach(CFG ${ALL_APP_CONFIGS})
        string(COMPARE EQUAL ${CFG} ${APP_CONFIG} _cmp)
        if(NOT ${_cmp})
            foreach(RM_FILE ${SOURCE_FILES_${CFG}})
                list(REMOVE_ITEM CONFIG_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/${RM_FILE})
            endforeach()
        endif()
    endforeach()
    set(${RET_CONFIG_SRCS} ${CONFIG_SRCS} PARENT_SCOPE)
    # TODO why cant we do this here? DIRECTORY?
endfunction()


function(do_pca SOURCE_FILE DOT_BUILD_DIR TARGET_FLAGS TARGET_INCDIRS RET_FILE_PCA)

    # Shorten path just to replicate what xcommon does for now
    # TODO should the xml files be generated into the cmake build dir?
    file(RELATIVE_PATH file_pca ${CMAKE_CURRENT_LIST_DIR} ${SOURCE_FILE})
    string(REPLACE "../" "" file_pca ${file_pca})
    string(REPLACE "lib_" "_l_" file_pca ${file_pca})
    get_filename_component(file_pca_dir ${file_pca} PATH)
    set(file_pca ${DOT_BUILD_DIR}/${file_pca}.pca.xml)
    set(file_pca_dir ${DOT_BUILD_DIR}/${file_pca_dir})
    add_custom_command(
        OUTPUT ${file_pca_dir}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${file_pca_dir}
    )

    # Need to pass file flags to PCA also
    get_source_file_property(FILE_FLAGS ${SOURCE_FILE} COMPILE_OPTIONS)
    get_source_file_property(FILE_INCDIRS ${SOURCE_FILE} INCLUDE_DIRECTORIES)

    string(COMPARE EQUAL "${FILE_FLAGS}" NOTFOUND _cmp)
    if(_cmp)
        set(FILE_FLAGS "")
    endif()

    string(COMPARE EQUAL "${FILE_INCDIRS}" NOTFOUND _cmp)
    if(_cmp)
        set(FILE_INCDIRS "")
    endif()

    # Turn FILE_FLAGS into a list so that xpca command treats them as separate arguments
    string(REPLACE " " ";" FILE_FLAGS "${FILE_FLAGS}")

    message(VERBOSE "Running PCA on ${SOURCE_FILE} with\nfile flags: ${FILE_FLAGS}\ntarget flags: ${TARGET_FLAGS}\ninto ${DOT_BUILD_DIR}")
    list(PREPEND FILE_FLAGS "${TARGET_FLAGS}")
    list(PREPEND FILE_INCDIRS "${TARGET_INCDIRS}")

    # Should probably also get the compile flags/definitions similar to pca_incdirs, and pass those to PCA
    add_custom_command(
       OUTPUT ${file_pca}
       COMMAND xcc -pre-compilation-analysis ${SOURCE_FILE} ${FILE_FLAGS} "$<$<BOOL:${FILE_INCDIRS}>:-I$<JOIN:${FILE_INCDIRS},;-I>>" -x none -o ${file_pca}
       DEPENDS ${SOURCE_FILE} ${file_pca_dir} ${APP_HW_TARGET_XN_FILE}
       VERBATIM
       COMMAND_EXPAND_LISTS
    )

    set(${RET_FILE_PCA} ${file_pca} PARENT_SCOPE)
endfunction()

# This macro clears variables when recursively processing dependencies, where those variables
# can have an effect on the child scope and need to be set within that scope by the
# lib_build_info.cmake which is included at that point.
macro(unset_lib_vars)
    # Clear source variables to allow globbing if they remain unset in a dependency
    unset(LIB_XC_SRCS)
    unset(LIB_C_SRCS)
    unset(LIB_CXX_SRCS)
    unset(LIB_ASM_SRCS)

    # Need to clear this to handle multiple static archive sub-dependencies
    unset(LIB_ARCHIVES)
endmacro()

# If source variables are blank, glob for source files; otherwise prepend the full path
# The prefix parameter is the prefix on the list variables _XC_SRCS, _C_SRCS, etc.
# The src_subdir parameter is the name of the directory in which to search for source
# files if none are specified.
macro(glob_srcs prefix src_dir src_subdir)
    if(NOT DEFINED ${prefix}_XC_SRCS)
        file(GLOB_RECURSE ${prefix}_XC_SRCS CONFIGURE_DEPENDS ${src_dir}/${src_subdir}/*.xc)
    else()
        list(TRANSFORM ${prefix}_XC_SRCS PREPEND ${src_dir}/)
    endif()

    if(NOT DEFINED ${prefix}_CXX_SRCS)
        file(GLOB_RECURSE ${prefix}_CXX_SRCS CONFIGURE_DEPENDS ${src_dir}/${src_subdir}/*.cpp)
    else()
        list(TRANSFORM ${prefix}_CXX_SRCS PREPEND ${src_dir}/)
    endif()

    if(NOT DEFINED ${prefix}_C_SRCS)
        file(GLOB_RECURSE ${prefix}_C_SRCS CONFIGURE_DEPENDS ${src_dir}/${src_subdir}/*.c)
    else()
        list(TRANSFORM ${prefix}_C_SRCS PREPEND ${src_dir}/)
    endif()

    if(NOT DEFINED ${prefix}_ASM_SRCS)
        file(GLOB_RECURSE ${prefix}_ASM_SRCS CONFIGURE_DEPENDS ${src_dir}/${src_subdir}/*.S)
    else()
        list(TRANSFORM ${prefix}_ASM_SRCS PREPEND ${src_dir}/)
    endif()

    if(NOT DEFINED ${prefix}_XSCOPE_SRCS)
        file(GLOB_RECURSE ${prefix}_XSCOPE_SRCS CONFIGURE_DEPENDS ${src_dir}/*.xscope)
    else()
        list(TRANSFORM ${prefix}_XSCOPE_SRCS PREPEND ${src_dir}/)
    endif()
endmacro()


function(parse_dep_string dep_str ret_repo ret_ver ret_name)
    # Extract version and remove version string with parentheses from original
    string(REGEX REPLACE "\\((.+)\\)" "" dep_str ${dep_str})

    if(CMAKE_MATCH_COUNT EQUAL 1)
        set(match_ver ${CMAKE_MATCH_1})

        # If a three-part version number was provided, prepend a "v" to get a tag.
        # Otherwise use the string that was given, assuming it to be a commit, branch or tag.
        string(REGEX MATCH "^[0-9]+\\.[0-9]+\\.[0-9]+$" match_tag ${match_ver})
        if(match_tag)
            string(PREPEND match_ver "v")
        endif()
    else()
        # No version specified, so get the head of the default branch
        set(match_ver HEAD)
    endif()

    set(${ret_ver} ${match_ver} PARENT_SCOPE)

    string(REGEX MATCH "/[a-zA-Z0-9\\._-]+$" match_name ${dep_str})
    if(match_name)
        string(REGEX REPLACE "/" "" match_name ${match_name})
    else()
        set(match_name ${dep_str})
    endif()
    set(${ret_name} ${match_name} PARENT_SCOPE)

    string(REGEX MATCH "^http|^HTTP" match_http ${dep_str})
    if(match_http)
        set(${ret_repo} ${dep_str} PARENT_SCOPE)
        return()
    endif()

    string(REGEX MATCH "^git@" match_ssh ${dep_str})
    if(match_ssh)
        set(${ret_repo} ${dep_str} PARENT_SCOPE)
        return()
    endif()

    string(REGEX REPLACE "^([a-zA-Z0-9\\._-]+):" "" dep_str ${dep_str})
    if(CMAKE_MATCH_COUNT EQUAL 1)
        set(match_server ${CMAKE_MATCH_1})
    else()
        set(match_server "github.com")
    endif()

    unset(ssh_host_status)

    get_property(SSH_HOST_SUCCESS GLOBAL PROPERTY SSH_HOST_SUCCESS)
    list(FIND SSH_HOST_SUCCESS ${match_server} found)
    if(NOT ${found} EQUAL -1)
        set(ssh_host_status TRUE)
    endif()

    get_property(SSH_HOST_FAILURE GLOBAL PROPERTY SSH_HOST_FAILURE)
    list(FIND SSH_HOST_FAILURE ${match_server} found)
    if(NOT ${found} EQUAL -1)
        set(ssh_host_status FALSE)
    endif()

    if(NOT DEFINED ssh_host_status)
        # This host isn't in either the success or failure list

        if(CMAKE_HOST_WIN32)
            # To avoid printing artifacts, provide an input file to the ssh command below.
            # This input file is an empty file which will be left in the CMAKE_BINARY_DIR.
            # The Windows NUL didn't work as an input.
            execute_process(COMMAND ${CMAKE_COMMAND} -E touch ${CMAKE_BINARY_DIR}/ssh-in.tmp
                            OUTPUT_QUIET
                            ERROR_QUIET)
            set(tmp_input_file ${CMAKE_BINARY_DIR}/ssh-in.tmp)
        else()
            set(tmp_input_file "/dev/null")
        endif()

        # Check whether SSH access is available (returns 1 on success, 255 on failure)
        execute_process(COMMAND ssh -o "StrictHostKeyChecking no" git@${match_server}
                        TIMEOUT 30
                        RESULT_VARIABLE ret
                        INPUT_FILE ${tmp_input_file}
                        OUTPUT_QUIET
                        ERROR_QUIET)
        if(ret EQUAL 1)
            set(ssh_host_status TRUE)
            list(APPEND SSH_HOST_SUCCESS ${match_server})
            set_property(GLOBAL PROPERTY SSH_HOST_SUCCESS ${SSH_HOST_SUCCESS})
            message(VERBOSE "SSH access to ${match_server} succeeded")
        else()
            set(ssh_host_status FALSE)
            list(APPEND SSH_HOST_FAILURE ${match_server})
            set_property(GLOBAL PROPERTY SSH_HOST_FAILURE ${SSH_HOST_FAILURE})
            message(VERBOSE "SSH access to ${match_server} failed")
        endif()
    endif()

    if(ssh_host_status)
        string(PREPEND match_server "git@")
        string(APPEND match_server ":")
    else()
        string(PREPEND match_server "https://")
        string(APPEND match_server "/")
    endif()

    string(REGEX REPLACE "^([a-zA-Z0-9\\._-]+)/" "" dep_str ${dep_str})
    if(CMAKE_MATCH_COUNT EQUAL 1)
        set(match_org ${CMAKE_MATCH_1})
    else()
        set(match_org "xmos")
    endif()

    # dep_str now just contains the repo
    set(${ret_repo} "${match_server}${match_org}/${dep_str}" PARENT_SCOPE)
endfunction()

# Append spaces to a string to pad it to the given length, returning the result in the ret_str variable
function(pad_string str total_len ret_str)
    string(LENGTH ${str} str_len)
    math(EXPR pad_len "${total_len} - ${str_len}")
    if(pad_len GREATER 0)
        string(REPEAT " " ${pad_len} pad_str)
        set(${ret_str} "${str}${pad_str}" PARENT_SCOPE)
    endif()
endfunction()

function(form_manifest_string name repo branch tag commit_hash status ret_str)
    if(NOT commit_hash)
        # Must not be in a git repo, so unset other variables
        set(commit_hash "-")
        unset(branch)
        unset(tag)
        unset(repo)
        unset(status)
    endif()

    if(NOT repo)
        set(repo "-")
    endif()

    if(NOT name)
        string(REGEX REPLACE "\\.git$" "" name ${repo})
        string(REGEX MATCH "/([a-zA-Z0-9\\._-]+)$" _m ${name})
        if(CMAKE_MATCH_COUNT EQUAL 1)
            set(name ${CMAKE_MATCH_1})
        else()
            set(name "-")
        endif()
    endif()

    # Prefer a tag reference over a branch
    if(tag)
        set(branch ${tag})
    endif()

    if(NOT branch)
        # Depending on the git version, a branch might be checked out by detaching the HEAD of that branch
        string(REGEX MATCH "^HEAD detached at ([a-zA-Z0-9\\._-]+/)?([a-zA-Z0-9\\._-]+)\n" _m "${status}")
        if(CMAKE_MATCH_COUNT GREATER 1)
            set(detached ${CMAKE_MATCH_${CMAKE_MATCH_COUNT}})
            if(commit_hash MATCHES "^${detached}")
                set(branch "-")
            else()
                set(branch "${detached}")
            endif()
        else()
            set(branch "-")
        endif()
    endif()

    set(manifest_str "${name}")
    pad_string(${manifest_str} 25 manifest_str)
    string(APPEND manifest_str " ${repo}")
    pad_string(${manifest_str} 75 manifest_str)
    string(APPEND manifest_str " ${branch}")
    pad_string(${manifest_str} 100 manifest_str)
    string(APPEND manifest_str " ${commit_hash}")

    set(${ret_str} ${manifest_str} PARENT_SCOPE)
endfunction()

macro(add_manifest_depends_on )
    if(${FULL_MANIFEST})
        pad_string(${manifest_str} 145 manifest_str)
        list(LENGTH LIB_DEPENDENT_MODULES DEP_COUNT)
        foreach(DEP_MODULE ${LIB_DEPENDENT_MODULES})
            parse_dep_string(${DEP_MODULE} DEP_REPO DEP_VERSION DEP_NAME)
            math(EXPR DEP_COUNT "${DEP_COUNT} - 1")
            set(manifest_str "${manifest_str} ${DEP_NAME}(${DEP_VERSION})")
            if(NOT DEP_COUNT EQUAL 0)
                set(manifest_str "${manifest_str},")
            endif()
        endforeach()
    endif()
endmacro()

# Called for the top-level app/lib and each module, this takes a name and version (either blank for the
# top-level app or provided by the module dependency specification), checks the git repo status to work out
# changeset hashes and tags, and then appends an entry in the manifest file for the module.
function(manifest_git_status name manifest_str_ret)
    if(NOT name)
        set(working_dir ${CMAKE_SOURCE_DIR})
    else()
        set(working_dir ${XMOS_SANDBOX_DIR}/${name})
    endif()

    execute_process(COMMAND git remote get-url origin
                    TIMEOUT 5
                    WORKING_DIRECTORY ${working_dir}
                    OUTPUT_VARIABLE repo
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_QUIET)

    execute_process(COMMAND git branch --show-current
                    TIMEOUT 5
                    WORKING_DIRECTORY ${working_dir}
                    OUTPUT_VARIABLE branch
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_QUIET)

    execute_process(COMMAND git rev-parse HEAD
                    TIMEOUT 5
                    WORKING_DIRECTORY ${working_dir}
                    OUTPUT_VARIABLE commit_hash
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_QUIET)

    execute_process(COMMAND git status
                    TIMEOUT 5
                    WORKING_DIRECTORY ${working_dir}
                    OUTPUT_VARIABLE status
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_QUIET)

    execute_process(COMMAND git describe --tags --exact-match HEAD
                    TIMEOUT 5
                    WORKING_DIRECTORY ${working_dir}
                    OUTPUT_VARIABLE tag
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_QUIET)

    form_manifest_string("${name}" "${repo}" "${branch}" "${tag}" "${commit_hash}" "${status}" manifest_str)

    set(${manifest_str_ret} ${manifest_str} PARENT_SCOPE)

endfunction()

macro(configure_optional_headers)
    string(REPLACE "lib_" "" auto_opthdr ${LIB_NAME})
    foreach(target ${APP_BUILD_TARGETS})
        get_target_property(opt_hdrs ${target} OPTIONAL_HEADERS)
        list(APPEND opt_hdrs ${LIB_OPTIONAL_HEADERS} ${auto_opthdr}_conf.h)
        list(REMOVE_DUPLICATES opt_hdrs)
        set_target_properties(${target} PROPERTIES OPTIONAL_HEADERS "${opt_hdrs}")
    endforeach()
endmacro()

## Registers an application and its dependencies
function(XMOS_REGISTER_APP)
    # Set this variable so that other code can tell whether it is being run within the scope
    # of an application-level build (rather than a static library build)
    set(XCOMMON_CMAKE_APP_BUILD TRUE)

    print_xcommon_cmake_version()

    message(STATUS "Configuring application: ${PROJECT_NAME}")

    if(NOT BUILD_NATIVE AND NOT APP_HW_TARGET)
        message(FATAL_ERROR "APP_HW_TARGET not set in application Cmakelists")
    endif()

    if(NOT APP_COMPILER_FLAGS)
        set(APP_COMPILER_FLAGS "")
    endif()

    ## Populate build flag for hardware target
    if(${APP_HW_TARGET} MATCHES ".*\\.xn$")
        # Check specified XN file exists
        file(GLOB_RECURSE xn_files CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/*.xn)
        list(FILTER xn_files INCLUDE REGEX ".*${APP_HW_TARGET}")
        list(LENGTH xn_files num_xn_files)
        if(NOT ${num_xn_files})
            message(FATAL_ERROR "XN file not found")
        endif()
        set(APP_TARGET_COMPILER_FLAG ${xn_files})
        message(VERBOSE "XN file: ${xn_files}")
        set(APP_HW_TARGET_XN_FILE ${xn_files})
    elseif(NOT BUILD_NATIVE)
        set(APP_TARGET_COMPILER_FLAG "-target=${APP_HW_TARGET}")
        message(VERBOSE "Hardware target: ${APP_HW_TARGET}")
    endif()

    glob_srcs("APP" ${CMAKE_CURRENT_SOURCE_DIR} src)

    set(ALL_SRCS_PATH ${APP_XC_SRCS} ${APP_ASM_SRCS} ${APP_C_SRCS} ${APP_CXX_SRCS})

    if(NOT BUILD_NATIVE)
        # Automatically determine architecture
        list(LENGTH ALL_SRCS_PATH num_srcs)
        if(NOT ${num_srcs} GREATER 0)
            message(FATAL_ERROR "No sources present to determine architecture")
        endif()
        list(GET ALL_SRCS_PATH 0 src0)
        execute_process(COMMAND xcc -dumpmachine ${APP_TARGET_COMPILER_FLAG} ${src0}
                        OUTPUT_VARIABLE APP_BUILD_ARCH
                        OUTPUT_STRIP_TRAILING_WHITESPACE)
    else()
        set(APP_BUILD_ARCH "${CMAKE_HOST_SYSTEM_PROCESSOR}")
    endif()
    message(VERBOSE "Building for architecture: ${APP_BUILD_ARCH}")
    set(APP_BUILD_ARCH ${APP_BUILD_ARCH} PARENT_SCOPE)

    # Find all build configs
    GET_ALL_VARS_STARTING_WITH("APP_COMPILER_FLAGS_" APP_COMPILER_FLAGS_VARS)

    set(APP_CONFIGS "")
    foreach(APP_FLAGS ${APP_COMPILER_FLAGS_VARS})
        string(REPLACE "APP_COMPILER_FLAGS_" "" APP_FLAGS ${APP_FLAGS})

        # Only consider "config" flags; ignore "file" flags
        if(NOT APP_FLAGS MATCHES "\\.")
            list(APPEND APP_CONFIGS ${APP_FLAGS})
        endif()
    endforeach()

    # Add any configs defined by SOURCE_FILES_<config> that aren't already in APP_CONFIGS
    GET_ALL_VARS_STARTING_WITH("SOURCE_FILES_" SOURCE_FILES_VARS)
    foreach(SOURCE_FILES_VAR ${SOURCE_FILES_VARS})
        string(REPLACE "SOURCE_FILES_" "" SOURCE_FILES_VAR ${SOURCE_FILES_VAR})
        list(FIND APP_CONFIGS ${SOURCE_FILES_VAR} found)
        if(${found} EQUAL -1)
            list(APPEND APP_CONFIGS ${SOURCE_FILES_VAR})
        endif()
    endforeach()

    # Somewhat follow the strategy of xcommon here with a config named "Default"
    list(LENGTH APP_CONFIGS CONFIGS_COUNT)
    if(${CONFIGS_COUNT} EQUAL 0)
        list(APPEND APP_CONFIGS "DEFAULT")
    endif()

        # Create app targets with config-specific options
    set(APP_BUILD_TARGETS "")
    foreach(APP_CONFIG ${APP_CONFIGS})
        # Check for the "Default" config we created if user didn't specify any configs
        if(${APP_CONFIG} STREQUAL "DEFAULT")
            add_executable(${PROJECT_NAME})
            target_sources(${PROJECT_NAME} PRIVATE ${ALL_SRCS_PATH})
            set_target_properties(${PROJECT_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin)
            target_include_directories(${PROJECT_NAME} PRIVATE ${APP_INCLUDES})
            target_compile_options(${PROJECT_NAME} PRIVATE ${APP_COMPILER_FLAGS} ${APP_TARGET_COMPILER_FLAG} ${APP_XSCOPE_SRCS})
            target_link_options(${PROJECT_NAME} PRIVATE ${APP_COMPILER_FLAGS} ${APP_TARGET_COMPILER_FLAG} ${APP_XSCOPE_SRCS})
            list(APPEND APP_BUILD_TARGETS ${PROJECT_NAME})
            set(${PROJECT_NAME}_DEPENDENT_ARCHIVES ${APP_DEPENDENT_ARCHIVES})
        else()
            add_executable(${PROJECT_NAME}_${APP_CONFIG})
            # If a single app is being configured, build targets can be named after the app configs; in the case of a multi-app
            # build, config names could coincide between applications, so these shorter named targets can't be used.
            if(CMAKE_CURRENT_LIST_DIR STREQUAL CMAKE_SOURCE_DIR)
                add_custom_target(${APP_CONFIG} DEPENDS ${PROJECT_NAME}_${APP_CONFIG})
            endif()
            remove_srcs("${APP_CONFIGS}" ${APP_CONFIG} "${ALL_SRCS_PATH}" config_srcs)
            target_sources(${PROJECT_NAME}_${APP_CONFIG} PRIVATE ${config_srcs})
            set_target_properties(${PROJECT_NAME}_${APP_CONFIG} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/bin/${APP_CONFIG})
            target_include_directories(${PROJECT_NAME}_${APP_CONFIG} PRIVATE ${APP_INCLUDES})
            target_compile_options(${PROJECT_NAME}_${APP_CONFIG} PRIVATE ${APP_COMPILER_FLAGS_${APP_CONFIG}} "-DCONFIG=${APP_CONFIG}" ${APP_TARGET_COMPILER_FLAG} ${APP_XSCOPE_SRCS})
            target_link_options(${PROJECT_NAME}_${APP_CONFIG} PRIVATE ${APP_COMPILER_FLAGS_${APP_CONFIG}} ${APP_TARGET_COMPILER_FLAG} ${APP_XSCOPE_SRCS})
            list(APPEND APP_BUILD_TARGETS ${PROJECT_NAME}_${APP_CONFIG})

            # Store dependent archives for each application target for linking later
            if(APP_DEPENDENT_ARCHIVES_${APP_CONFIG})
                set(${PROJECT_NAME}_${APP_CONFIG}_DEPENDENT_ARCHIVES ${APP_DEPENDENT_ARCHIVES_${APP_CONFIG}})
            else()
                set(${PROJECT_NAME}_${APP_CONFIG}_DEPENDENT_ARCHIVES ${APP_DEPENDENT_ARCHIVES})
            endif()
        endif()
    endforeach()
    if(APP_HW_TARGET_XN_FILE)
        set_source_files_properties(${ALL_SRCS_PATH}
                                    TARGET_DIRECTORY ${APP_BUILD_TARGETS}
                                    PROPERTIES OBJECT_DEPENDS ${APP_HW_TARGET_XN_FILE})
    endif()
    set(APP_BUILD_TARGETS ${APP_BUILD_TARGETS} PARENT_SCOPE)

    if(${CONFIGS_COUNT} EQUAL 0)
        # Only print the default-only config at the verbose log level
        message(VERBOSE "Found build config:")
        message(VERBOSE "DEFAULT")
    else()
        message(STATUS "Found build configs:")
        foreach(cfg ${APP_CONFIGS})
            message(STATUS "${cfg}")
        endforeach()
    endif()

    add_file_flags("APP" "${ALL_SRCS_PATH}")

    set(LIB_DEPENDENT_MODULES ${APP_DEPENDENT_MODULES})

    if(DEFINED XMOS_DEPS_ROOT_DIR)
        message(WARNING "XMOS_DEPS_ROOT_DIR is deprecated; please use XMOS_SANDBOX_DIR instead")
        if(NOT DEFINED XMOS_SANDBOX_DIR)
            set(XMOS_SANDBOX_DIR "${XMOS_DEPS_ROOT_DIR}")
        endif()
    endif()
    if(LIB_DEPENDENT_MODULES AND NOT XMOS_SANDBOX_DIR)
        message(FATAL_ERROR "XMOS_SANDBOX_DIR must be set as the root directory of the sandbox")
    endif()
    cmake_path(SET XMOS_SANDBOX_DIR NORMALIZE "${XMOS_SANDBOX_DIR}")
    message(VERBOSE "XMOS_SANDBOX_DIR: ${XMOS_SANDBOX_DIR}")

    set_property(GLOBAL PROPERTY BUILD_ADDED_DEPS "")

    # Overwrites file if already present and then record manifest entry for application repo
    file(WRITE ${MANIFEST_OUT} ${MANIFEST_HEADER})
    manifest_git_status("" manifest_str)

    # Create the Depends_on column in manifest
    add_manifest_depends_on()

    file(APPEND ${MANIFEST_OUT} "${manifest_str}\n")

    set(current_module ${PROJECT_NAME})
    XMOS_REGISTER_DEPS("${APP_DEPENDENT_MODULES}")

    foreach(target ${APP_BUILD_TARGETS})
        get_target_property(all_inc_dirs ${target} INCLUDE_DIRECTORIES)
        get_target_property(all_opt_hdrs ${target} OPTIONAL_HEADERS)
        set(opt_hdrs_found "")
        foreach(inc ${all_inc_dirs})
            file(GLOB headers CONFIGURE_DEPENDS ${inc}/*.h)
            foreach(header ${headers})
                get_filename_component(name ${header} NAME)
                list(FIND all_opt_hdrs ${name} FOUND)
                if(${FOUND} GREATER -1)
                    get_filename_component(name_we ${header} NAME_WE)
                    list(FIND opt_hdrs_found ${name_we} dup_found)
                    if(${dup_found} EQUAL -1)
                        target_compile_options(${target} PRIVATE "-D__${name_we}_h_exists__")
                        list(APPEND opt_hdrs_found ${name_we})
                    else()
                        message(WARNING "Optional header ${header} already found for target ${target}")
                    endif()
                 endif()
            endforeach()
        endforeach()
    endforeach()

    if(APP_PCA_ENABLE AND NOT BUILD_NATIVE)
        message(STATUS "Generating commands for Pre-Compilation Analysis (PCA)")
        foreach(target ${APP_BUILD_TARGETS})
            string(REGEX REPLACE "${PROJECT_NAME}" "" DOT_BUILD_SUFFIX ${target})
            set(DOT_BUILD_DIR ${CMAKE_CURRENT_LIST_DIR}/.build${DOT_BUILD_SUFFIX})
            set_directory_properties(PROPERTIES ADDITIONAL_CLEAN_FILES ${DOT_BUILD_DIR})

            set(PCA_FILES_PATH "")

            get_target_property(target_srcs ${target} SOURCES)

            # Filter sources so that the only sources are XC
            list(FILTER target_srcs INCLUDE REGEX "\\.xc$")

            get_target_property(target_link_libs ${target} LINK_LIBRARIES)
            list(FILTER target_link_libs EXCLUDE REGEX "^.+-NOTFOUND$")
            set(static_incdirs "")
            foreach(lib ${target_link_libs})
                get_target_property(lib_incdirs ${lib} INTERFACE_INCLUDE_DIRECTORIES)
                list(APPEND static_incdirs ${lib_incdirs})
            endforeach()

            get_target_property(target_flags ${target} COMPILE_OPTIONS)
            get_target_property(target_incdirs ${target} INCLUDE_DIRECTORIES)
            list(APPEND target_incdirs ${static_incdirs})
            list(FILTER target_incdirs EXCLUDE REGEX "^.+-NOTFOUND$")

            foreach(file ${target_srcs})
                do_pca(${file} ${DOT_BUILD_DIR} "${target_flags}" "${target_incdirs}" file_pca)
                list(APPEND PCA_FILES_PATH ${file_pca})
            endforeach()

            get_property(BUILD_ADDED_DEPS_PATH GLOBAL PROPERTY BUILD_ADDED_DEPS)

            list(TRANSFORM BUILD_ADDED_DEPS_PATHS PREPEND ${XMOS_SANDBOX_DIR}/)

            string(REPLACE ";" "\" \"" PCA_FILES_PATH_STR "${PCA_FILES_PATH}")
            set(PCA_FILES_RESP ${CMAKE_BINARY_DIR}/${target}/_pca.rsp)
            file(WRITE ${PCA_FILES_RESP} "\"${PCA_FILES_PATH_STR}\"")

            set(PCA_FILE ${DOT_BUILD_DIR}/pca.xml)
            add_custom_command(
                    OUTPUT ${PCA_FILE}
                    COMMAND $ENV{XMOS_TOOL_PATH}/libexec/xpca ${PCA_FILE} -deps ${DOT_BUILD_DIR}/pca.d ${DOT_BUILD_DIR} "\"${BUILD_ADDED_DEPS_PATHS} \"" @${PCA_FILES_RESP}
                    DEPENDS ${PCA_FILES_PATH}
                    DEPFILE ${DOT_BUILD_DIR}/pca.d
                    COMMAND_EXPAND_LISTS
                )

            set(PCA_FLAG "SHELL: -Xcompiler-xc -analysis" "SHELL: -Xcompiler-xc \"${DOT_BUILD_DIR}/pca.xml\"")
            target_compile_options(${target} PRIVATE ${PCA_FLAG})
            target_sources(${target} PRIVATE ${PCA_FILE})
        endforeach()
    endif()
endfunction()

# Configures the contents of a library directory for use with all the APP_BUILD_TARGETS. This function
# can be used with either a module or a static library based on the STATIC_LIB_BOOL variable.
function(configure_lib STATIC_LIB_BOOL)
    # If major version requirement was set, warn if there is a mismatch
    if(NOT "${DEP_MAJOR_VER}" STREQUAL "")
        string(REGEX MATCH "^([0-9]+)\\." _m ${LIB_VERSION})
        if(CMAKE_MATCH_COUNT EQUAL 1)
            if(NOT ${DEP_MAJOR_VER} EQUAL ${CMAKE_MATCH_1})
                message(WARNING "Expected major version ${DEP_MAJOR_VER} for ${LIB_NAME} but got ${CMAKE_MATCH_1}")
            endif()
        else()
            message(WARNING "Invalid LIB_VERSION ${LIB_VERSION} for ${LIB_NAME}")
        endif()
    endif()

    # DEP_NAME was set in XMOS_REGISTER_DEPS as the expected name of the module
    if(NOT LIB_NAME STREQUAL DEP_NAME)
        message(WARNING "Module ${DEP_NAME} has mismatched LIB_NAME: ${LIB_NAME}")
    endif()
    set(current_module ${LIB_NAME})
    XMOS_REGISTER_DEPS("${LIB_DEPENDENT_MODULES}")

    foreach(file ${LIB_ASM_SRCS})
        get_filename_component(ABS_PATH ${file} ABSOLUTE)
        set_source_files_properties(${ABS_PATH} PROPERTIES LANGUAGE ASM)
    endforeach()

    glob_srcs("LIB" ${module_dir} src)

    set_source_files_properties(${LIB_XC_SRCS} ${LIB_CXX_SRCS} ${LIB_ASM_SRCS} ${LIB_C_SRCS}
                                TARGET_DIRECTORY ${APP_BUILD_TARGETS}
                                PROPERTIES COMPILE_OPTIONS "${LIB_COMPILER_FLAGS}")

    GET_ALL_VARS_STARTING_WITH("LIB_COMPILER_FLAGS_" LIB_COMPILER_FLAGS_VARS)
    set(ALL_LIB_SRCS_PATH ${LIB_XC_SRCS} ${LIB_CXX_SRCS} ${LIB_ASM_SRCS} ${LIB_C_SRCS})
    add_file_flags("LIB" "${ALL_LIB_SRCS_PATH}")

    if(APP_HW_TARGET_XN_FILE)
        set_source_files_properties(${ALL_LIB_SRCS_PATH}
                                    TARGET_DIRECTORY ${APP_BUILD_TARGETS}
                                    PROPERTIES OBJECT_DEPENDS ${APP_HW_TARGET_XN_FILE})
    endif()

    list(TRANSFORM LIB_INCLUDES PREPEND ${module_dir}/)

    foreach(target ${APP_BUILD_TARGETS})
        target_include_directories(${target} PRIVATE ${LIB_INCLUDES})
    endforeach()

    # Don't add sources to static library targets as "wrapping" of static libraries is not supported
    if(XCOMMON_CMAKE_APP_BUILD OR NOT STATIC_LIB_BOOL)
        foreach(target ${APP_BUILD_TARGETS})
            target_sources(${target} PRIVATE ${ALL_LIB_SRCS_PATH})
        endforeach()

        configure_optional_headers()
    endif()
endfunction()

## Registers a module and its dependencies
function(XMOS_REGISTER_MODULE)
    configure_lib(FALSE)
endfunction()

## Registers the dependencies in the LIB_DEPENDENT_MODULES variable; DEPS_LIST parameter is the list of
## dependencies in the format of LIB_DEPENDENT_MODULES or LIB_ARCHIVE_DEPENDENT_MODULES
function(XMOS_REGISTER_DEPS DEPS_LIST)
    if(deps_list)
        # Only print if the dependent modules list parameter is non-empty
        message(VERBOSE "Registering dependencies of ${current_module}: ${DEPS_LIST}")
    endif()

    foreach(DEP_MODULE ${DEPS_LIST})
        parse_dep_string(${DEP_MODULE} DEP_REPO DEP_VERSION DEP_NAME)
        message(VERBOSE "Dependency: ${DEP_NAME}, repository ${DEP_REPO}, version ${DEP_VERSION}")

        string(REGEX MATCH "^v?([0-9]+)\\.[0-9]+\\.[0-9]+$" _m ${DEP_VERSION})
        if(CMAKE_MATCH_COUNT EQUAL 1)
            set(DEP_MAJOR_VER ${CMAKE_MATCH_1})
        else()
            set(DEP_MAJOR_VER "")
        endif()

        get_property(BUILD_ADDED_DEPS GLOBAL PROPERTY BUILD_ADDED_DEPS)

        # Check if this dependency has already been added
        list(FIND BUILD_ADDED_DEPS ${DEP_NAME} found)
        if(${found} EQUAL -1)
            list(APPEND BUILD_ADDED_DEPS ${DEP_NAME})

            # Set GLOBAL PROPERTY rather than PARENT_SCOPE since we may have multiple directory layers
            set_property(GLOBAL PROPERTY BUILD_ADDED_DEPS ${BUILD_ADDED_DEPS})

            if(DEFINED XMOS_DEP_DIR_${DEP_NAME})
                message(VERBOSE "${DEP_NAME} location overridden to ${XMOS_DEP_DIR_${DEP_NAME}}")
                set(dep_dir ${XMOS_DEP_DIR_${DEP_NAME}})

                if(NOT EXISTS ${dep_dir})
                    message(FATAL_ERROR "Dependency ${DEP_NAME} not present at ${dep_dir}")
                endif()
            else()
                set(dep_dir ${XMOS_SANDBOX_DIR}/${DEP_NAME})
            endif()
            cmake_path(SET dep_dir NORMALIZE ${dep_dir})

            # Fetch dependency if not present
            if(NOT IS_DIRECTORY ${dep_dir})
                message(STATUS "Fetching ${DEP_NAME}: ${DEP_VERSION} from ${DEP_REPO} into ${dep_dir}")
                FetchContent_Declare(
                    ${DEP_NAME}
                    GIT_REPOSITORY ${DEP_REPO}
                    GIT_TAG ${DEP_VERSION}
                    SOURCE_DIR ${dep_dir}
                    GIT_SHALLOW ${DEPS_CLONE_SHALLOW}
                )
                FetchContent_Populate(${DEP_NAME})
            endif()

            # Clear source variables to avoid inheriting from parent scope
            # Either lib_build_info.cmake will populate these, otherwise we glob for them
            unset_lib_vars()

            set(module_dir ${dep_dir}/${DEP_NAME})
            message(STATUS "Adding dependency ${DEP_NAME}")
            include(${module_dir}/lib_build_info.cmake)

            manifest_git_status(${DEP_NAME} manifest_str)

            # Create the Depends_on column in manifest
            add_manifest_depends_on()
            file(APPEND ${MANIFEST_OUT} "${manifest_str}\n")
        endif()
    endforeach()

endfunction()

# Takes as input the LIB_NAME or archive name from LIB_ARCHIVES, and removes the toolchain's
# static library prefix if necessary to avoid the resulting archive being called liblib_foo
function(get_archive_name IN_NAME RET_NAME)
    if(CMAKE_STATIC_LIBRARY_PREFIX)
        string(REGEX REPLACE "^${CMAKE_STATIC_LIBRARY_PREFIX}" "" archive_name ${IN_NAME})
    else()
        set(archive_name ${IN_NAME})
    endif()
    set(${RET_NAME} ${archive_name} PARENT_SCOPE)
endfunction()

## Registers a static library target
function(XMOS_STATIC_LIBRARY)
    print_xcommon_cmake_version()
    message(STATUS "Configuring static library: ${LIB_NAME}")

    glob_srcs("LIB_ARCHIVE" ${CMAKE_CURRENT_SOURCE_DIR} libsrc)

    if(NOT LIB_ARCHIVES)
        set(LIB_ARCHIVES ${LIB_NAME})
        if(NOT LIB_ARCHIVE_COMPILER_FLAGS_${LIB_NAME})
            set(LIB_ARCHIVE_COMPILER_FLAGS_${LIB_NAME} "${LIB_ARCHIVE_COMPILER_FLAGS}")
        endif()
    endif()

    set(APP_BUILD_TARGETS "")
    foreach(archive ${LIB_ARCHIVES})
        if(NOT BUILD_NATIVE)
            if(LIB_ARCHIVE_ARCHS_${archive})
                set(arch_list ${LIB_ARCHIVE_ARCHS_${archive}})
            elseif(LIB_ARCHIVE_ARCHS)
                set(arch_list ${LIB_ARCHIVE_ARCHS})
            else()
                set(arch_list ${DEFAULT_STATICLIB_ARCH})
            endif()
        else()
            set(arch_list ${CMAKE_HOST_SYSTEM_PROCESSOR})
        endif()

        foreach(arch ${arch_list})
            set(APP_BUILD_ARCH ${arch})
            set(archive_target ${archive}-${arch})
            message(VERBOSE "Building ${archive} for architecture: {arch}")

            add_library(${archive_target} STATIC)
            set_property(TARGET ${archive_target} PROPERTY VERSION ${LIB_VERSION})
            target_sources(${archive_target} PRIVATE ${LIB_ARCHIVE_XC_SRCS} ${LIB_ARCHIVE_CXX_SRCS} ${LIB_ARCHIVE_ASM_SRCS} ${LIB_ARCHIVE_C_SRCS})
            target_include_directories(${archive_target} PRIVATE ${LIB_ARCHIVE_INCLUDES})
            if(NOT BUILD_NATIVE)
                target_compile_options(${archive_target} PUBLIC "-march=${arch}" ${LIB_ARCHIVE_COMPILER_FLAGS_${archive}})
            endif()

            set_property(TARGET ${archive_target} PROPERTY ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib/${arch})
            get_archive_name(${archive} archive_name)
            set_property(TARGET ${archive_target} PROPERTY ARCHIVE_OUTPUT_NAME ${archive_name})

            list(APPEND APP_BUILD_TARGETS ${archive_target})
        endforeach()
    endforeach()
    set(APP_BUILD_TARGETS ${APP_BUILD_TARGETS} PARENT_SCOPE)

    if(DEFINED XMOS_DEPS_ROOT_DIR)
        message(WARNING "XMOS_DEPS_ROOT_DIR is deprecated; please use XMOS_SANDBOX_DIR instead")
        if(NOT DEFINED XMOS_SANDBOX_DIR)
            set(XMOS_SANDBOX_DIR "${XMOS_DEPS_ROOT_DIR}")
        endif()
    endif()
    if(LIB_ARCHIVE_DEPENDENT_MODULES AND NOT XMOS_SANDBOX_DIR)
        message(FATAL_ERROR "XMOS_SANDBOX_DIR must be set as the root directory of the sandbox")
    endif()
    cmake_path(SET XMOS_SANDBOX_DIR NORMALIZE "${XMOS_SANDBOX_DIR}")
    message(VERBOSE "XMOS_SANDBOX_DIR: ${XMOS_SANDBOX_DIR}")

    set_property(GLOBAL PROPERTY BUILD_ADDED_DEPS "")

    # Overwrites file if already present and then record manifest entry for application repo
    file(WRITE ${MANIFEST_OUT} ${MANIFEST_HEADER})
    manifest_git_status("" "" manifest_str)
    file(APPEND ${MANIFEST_OUT} "${manifest_str}\n")

    set(current_module ${LIB_NAME})
    XMOS_REGISTER_DEPS("${LIB_ARCHIVE_DEPENDENT_MODULES}")
endfunction()

# Either configures the build of the static library or links the static library into the application
function(XMOS_REGISTER_STATIC_LIB)
    # The variable module_dir will be set if this function is called as result of application dependency
    # resolution, in which case the static library is linked into the application. If this variable is
    # not set, XMOS_STATIC_LIBRARY() is called to configure the build of the static library itself.
    if(NOT module_dir)
        # Configure build of static lib
        XMOS_STATIC_LIBRARY()
    else()

        # Handle any additional source files as though they are in a standard module repository
        configure_lib(TRUE)

        # If not configuring an application target, then don't need to link static library archives
        if(NOT XCOMMON_CMAKE_APP_BUILD)
            return()
        endif()

        # Configure use of prebuilt static lib

        if(LIB_ARCHIVES)
            set(archive_names ${LIB_ARCHIVES})
        else()
            set(archive_names ${LIB_NAME})
        endif()

        list(TRANSFORM LIB_INCLUDES PREPEND ${module_dir}/)
        list(TRANSFORM LIB_ARCHIVE_INCLUDES PREPEND ${module_dir}/)

        foreach(target ${APP_BUILD_TARGETS})
            list(LENGTH archive_names num_archives)
            set(search_archives "")
            if(num_archives EQUAL 1)
                set(search_archives ${archive_names})
            endif()
            # Also search in the application config-specific archives
            list(APPEND search_archives ${${target}_DEPENDENT_ARCHIVES})

            set(dep_archives "")
            foreach(archive ${archive_names})
                list(FIND search_archives ${archive} found)
                if(NOT ${found} EQUAL -1)
                    list(APPEND dep_archives ${archive})
                endif()
            endforeach()

            foreach(archive ${dep_archives})
                # Create static library archive target if it hasn't been created yet
                if(NOT TARGET ${archive})
                    add_library(${archive} STATIC IMPORTED)
                    set_property(TARGET ${archive} PROPERTY SYSTEM OFF)

                    get_archive_name(${archive} archive_name)
                    set(archive_filename ${CMAKE_STATIC_LIBRARY_PREFIX}${archive_name}${CMAKE_STATIC_LIBRARY_SUFFIX})
                    set(archive_path ${module_dir}/lib/${APP_BUILD_ARCH}/${archive_filename})
                    if(NOT EXISTS ${archive_path})
                        message(FATAL_ERROR "${archive_filename} static library archive not present at ${archive_path}")
                    endif()
                    set_property(TARGET ${archive} PROPERTY IMPORTED_LOCATION ${archive_path})
                endif()
            endforeach()

            target_link_libraries(${target} PRIVATE ${dep_archives})
        endforeach()
    endif()
endfunction()
