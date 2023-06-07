cmake_minimum_required(VERSION 3.14)

# Set up compiler
# This env var should be setup by tools, or we can potentially infer from XMOS_MAKE_PATH
if(NOT DEFINED ${CMAKE_TOOLCHAIN_FILE})
    include("$ENV{XMOS_CMAKE_PATH}/xmos_cmake_toolchain/xcore.cmake")
endif()

if(PROJECT_SOURCE_DIR)
    message(FATAL_ERROR "xmos_utils.cmake must be included before a project definition")
endif()

enable_language(CXX C ASM)

# Check that supported bitstream has been specified
#include("bitstream_src/supported_hw.cmake")
#if(DEFINED BOARD)
#    if(${BOARD} IN_LIST SUPPORTED_HW)
#        include("bitstream_src/${BOARD}/board.cmake")
#    else()
#        message("\nConfiguration for ${BOARD} not found.\nPreconfigured bitstreams are:")
#        foreach(HW ${SUPPORTED_HW})
#            message("\t${HW}")
#        endforeach()
#        message(FATAL_ERROR "")
#    endif()
#else()
#    message("\n-DBOARD must be specified.\nPreconfigured bitstreams are:")
#    foreach(HW ${SUPPORTED_HW})
#        message("\t${HW}")
#    endforeach()
#    message(FATAL_ERROR "")
#endif()

## Setup at caller scope

# Set up some XMOS specific variables
set(FULL 1 )
set(BITSTREAM_ONLY 2 )
set(BSP_ONLY 3 )
define_property(TARGET PROPERTY OPTIONAL_HEADERS BRIEF_DOCS "Contains list of optional headers." FULL_DOCS "Contains a list of optional headers.  The application level should search through all app includes and define D__[header]_h_exists__ for each header that is in both the app and optional headers.")
define_property(GLOBAL PROPERTY XMOS_TARGETS_LIST BRIEF_DOCS "brief" FULL_DOCS "full")

function (GET_ALL_VARS_STARTING_WITH _prefix _varResult)
    get_cmake_property(_vars VARIABLES)
    string (REGEX MATCHALL "(^|;)${_prefix}[A-Za-z0-9_\\.]*" _matchedVars "${_vars}")
    set (${_varResult} ${_matchedVars} PARENT_SCOPE)
endfunction()

macro(add_app_file_flags)
    foreach(SRC_FILE_PATH ${ALL_SRCS_PATH})
       
        # Over-ride file flags if APP_COMPILER_FLAGS_<source_file> is set
        get_filename_component(SRC_FILE ${SRC_FILE_PATH} NAME)
        foreach(FLAG_FILE ${APP_FLAG_FILES})
            string(COMPARE EQUAL ${FLAG_FILE} ${SRC_FILE} _cmp)
            if(_cmp)
                set(flags ${APP_COMPILER_FLAGS_${FLAG_FILE}})
                set_source_files_properties(${SRC_FILE_PATH} PROPERTIES COMPILE_FLAGS ${flags})
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
                list(REMOVE_ITEM CONFIG_SRCS ${CMAKE_CURRENT_SOURCE_DIR}/src/${RM_FILE})
            endforeach()
        endif()
    endforeach()
    set(${RET_CONFIG_SRCS} ${CONFIG_SRCS} PARENT_SCOPE)
    # TODO why cant we do this here? DIRECTORY? 
endfunction()


function(do_pca SOURCE_FILE DO_PCA_FLAGS DOT_BUILD_DIR RET_FILE_PCA)

    message(STATUS "Running PCA on ${SOURCE_FILE} with ${DO_PCA_FLAGS}")
    
    # Shorten path just to replicate what xcommon does for now
    # TODO should the xml files be generated into the cmake build dir?
    file(RELATIVE_PATH file_pca ${CMAKE_SOURCE_DIR} ${SOURCE_FILE})
    string(REPLACE "../lib_" "_l_" file_pca ${file_pca})
    get_filename_component(file_pca_dir ${file_pca} PATH)
    set(file_pca ${DOT_BUILD_DIR}${file_pca}.pca.xml)
    set(file_pca_dir ${DOT_BUILD_DIR}/${file_pca_dir})
    file(MAKE_DIRECTORY ${file_pca_dir})

    # Need to pass file flags to PCA also 
    get_source_file_property(FILE_FLAGS ${SOURCE_FILE} COMPILE_FLAGS)
  
    string(COMPARE EQUAL ${FILE_FLAGS} NOTFOUND _cmp)
    if(_cmp)
        set(FILE_FLAGS "")
    endif()

    # Turn FILE_FLAGS into a list so that xpca command treats them as separate arguments
    string(REPLACE " " ";" FILE_FLAGS "${FILE_FLAGS}")

    #TODO INTERFACE_INCLUDE_DIRECTOTIES?
    set(pca_incdirs "$<TARGET_PROPERTY:${BINARY_NAME},INCLUDE_DIRECTORIES>")

    # Should probably also get the compile flags/definitions similar to pca_incdirs, and pass those to PCA
    add_custom_command(
       OUTPUT ${file_pca}
       COMMAND xcc -pre-compilation-analysis ${_file} ${DO_PCA_FLAGS} "$<$<BOOL:${pca_incdirs}>:-I$<JOIN:${pca_incdirs},;-I>>" ${FILE_FLAGS} -x none -o ${file_pca}
       DEPENDS ${_file}
       VERBATIM
       COMMAND_EXPAND_LISTS
    )

    set_property(SOURCE ${file_pca} APPEND PROPERTY OBJECT_DEPENDS ${SOURCE_FILE})
    set(${RET_FILE_PCA} ${file_pca} PARENT_SCOPE)
endfunction()


## Registers an application and it's dependencies
function(XMOS_REGISTER_APP)
    # Setup lib build output
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/libs")

    # Setup build output
    file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${BOARD}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${BOARD}")

    if(NOT APP_HW_TARGET)
        message(FATAL_ERROR "APP_HW_TARGET not set in application Cmakelists")
    endif()

    if(NOT APP_COMPILER_FLAGS)
        set(APP_COMPILER_FLAGS "")
    endif()

    ## Populate build flag for hardware target
    if(${APP_HW_TARGET} MATCHES ".*\\.xn$")
        # Check specified XN file exists
        file(GLOB_RECURSE xn_files ${CMAKE_CURRENT_SOURCE_DIR}/*.xn)
        list(FILTER xn_files INCLUDE REGEX ".*${APP_HW_TARGET}")
        list(LENGTH xn_files num_xn_files) 
        if(NOT ${num_xn_files})
            message(FATAL_ERROR "XN file not found")
        endif()
        set(APP_TARGET_COMPILER_FLAG ${xn_files})
    else()
        set(APP_TARGET_COMPILER_FLAG "-target=${APP_HW_TARGET}")
    endif()

    #if(DEFINED THIS_XCORE_TILE)
    #    list(APPEND APP_COMPILER_FLAGS "-DTHIS_XCORE_TILE=${THIS_XCORE_TILE}")
    #endif()

    if(NOT APP_XC_SRCS)
        file(GLOB_RECURSE APP_XC_SRCS src/*.xc)
    else()
        list(TRANSFORM APP_XC_SRCS PREPEND ${CMAKE_CURRENT_SOURCE_DIR}/)
    endif()

    if(NOT APP_CXX_SRCS)
        file(GLOB_RECURSE APP_CXX_SRCS src/*.cpp)
    else()
        list(TRANSFORM APP_CXX_SRCS PREPEND ${CMAKE_CURRENT_SOURCE_DIR}/)
    endif()

    if(NOT APP_C_SRCS)
        file(GLOB_RECURSE APP_C_SRCS src/*.c)
    else()
        list(TRANSFORM APP_C_SRCS PREPEND ${CMAKE_CURRENT_SOURCE_DIR}/)
    endif()

    if(NOT APP_ASM_SRCS)
        file(GLOB_RECURSE APP_ASM_SRCS src/*.S)
    else()
        list(TRANSFORM APP_ASM_SRCS PREPEND ${CMAKE_CURRENT_SOURCE_DIR}/)
    endif()

    if(NOT APP_XSCOPE_SRCS)
        file(GLOB_RECURSE APP_XSCOPE_SRCS *.xscope)
    else()
        list(TRANSFORM APP_XSCOPE_SRCS PREPEND ${CMAKE_CURRENT_SOURCE_DIR}/)
    endif()

    set(ALL_SRCS_PATH ${APP_XC_SRCS} ${APP_ASM_SRCS} ${APP_C_SRCS} ${APP_CXX_SRCS} ${APP_XSCOPE_SRCS})

    list(LENGTH ALL_SRCS_PATH num_srcs)
    if(NOT ${num_srcs} GREATER 0)
        message(FATAL_ERROR "No sources present to determine architecture")
    endif()
    list(GET ALL_SRCS_PATH 0 src0)
    execute_process(COMMAND xcc -dumpmachine ${APP_TARGET_COMPILER_FLAG} ${src0}
                    OUTPUT_VARIABLE APP_BUILD_ARCH
                    OUTPUT_STRIP_TRAILING_WHITESPACE)

    set(LIB_NAME ${PROJECT_NAME}_LIB)
    set(LIB_VERSION ${PROJECT_VERSION})
    set(LIB_ADD_COMPILER_FLAGS ${APP_COMPILER_FLAGS} ${BOARD_COMPILE_FLAGS})
    set(LIB_XC_SRCS ${APP_XC_SRCS} ${BOARD_XC_SRCS})
    set(LIB_CXX_SRCS ${APP_CXX_SRCS} ${BOARD_CXX_SRCS})
    set(LIB_C_SRCS ${APP_C_SRCS} ${BOARD_C_SRCS})
    set(LIB_ASM_SRCS ${APP_ASM_SRCS} ${BOARD_ASM_SRCS})
    set(LIB_INCLUDES ${APP_INCLUDES} ${BOARD_INCLUDES})
    set(LIB_DEPENDENT_MODULES ${APP_DEPENDENT_MODULES})
    set(LIB_OPTIONAL_HEADERS "")
    set(LIB_FILE_FLAGS "")

    XMOS_REGISTER_MODULE("silent")

    get_target_property(${PROJECT_NAME}_LIB_SRCS ${PROJECT_NAME}_LIB SOURCES)
    get_target_property(${PROJECT_NAME}_LIB_INCS ${PROJECT_NAME}_LIB INCLUDE_DIRECTORIES)
    get_target_property(${PROJECT_NAME}_LIB_OPTINCS ${PROJECT_NAME}_LIB OPTIONAL_HEADERS)
    get_target_property(${PROJECT_NAME}_LIB_FILE_FLAGS ${PROJECT_NAME}_LIB FILE_FLAGS)

    set(APP_SOURCES ${APP_XC_SRCS} ${BOARD_XC_SRCS} ${APP_CXX_SRCS} ${BOARD_CXX_SRCS} ${APP_C_SRCS} ${BOARD_C_SRCS} ${APP_ASM_SRCS} ${BOARD_ASM_SRCS})
    set(APP_INCLUDES ${APP_INCLUDES} ${BOARD_INCLUDES})

    get_property(XMOS_TARGETS_LIST GLOBAL PROPERTY XMOS_TARGETS_LIST)

    foreach(lib ${XMOS_TARGETS_LIST})
        get_target_property(libtype ${lib} TYPE)
        if(${libtype} MATCHES STATIC_LIBRARY)
            get_target_property(inc ${lib} INTERFACE_INCLUDE_DIRECTORIES)
            list(APPEND APP_INCLUDES ${inc})
        endif()
    endforeach()

    list(REMOVE_DUPLICATES APP_SOURCES)
    list(REMOVE_DUPLICATES APP_INCLUDES)

    # Only define header exists, if header optional
    foreach(inc ${APP_INCLUDES})
        file(GLOB headers ${inc}/*.h)
        foreach(header ${headers})
            get_filename_component(name ${header} NAME)
            list(FIND ${PROJECT_NAME}_LIB_OPTINCS ${name} FOUND)
            if(${FOUND} GREATER -1)
                get_filename_component(name_we ${header} NAME_WE)
                list(APPEND HEADER_EXISTS_FLAGS -D__${name_we}_h_exists__)
            endif()
        endforeach()
    endforeach()

    # Find all build configs
    GET_ALL_VARS_STARTING_WITH("APP_COMPILER_FLAGS_" APP_COMPILER_FLAGS_VARS)

    set(APP_CONFIGS "")
    set(APP_FLAG_FILES "")
    foreach(APP_FLAGS ${APP_COMPILER_FLAGS_VARS})
        string(REPLACE "APP_COMPILER_FLAGS_" "" APP_FLAGS ${APP_FLAGS})

        # Ignore any "file" flags 
        if(NOT APP_FLAGS MATCHES "\\.")
            list(APPEND APP_CONFIGS ${APP_FLAGS})
        else()
            list(APPEND APP_FLAG_FILES ${APP_FLAGS})
        endif()
        
    endforeach()

    # Somewhat follow the strategy of xcommon here with a config named "Default" 
    list(LENGTH APP_CONFIGS CONFIGS_COUNT) 
    if(${CONFIGS_COUNT} EQUAL 0)
        list(APPEND APP_CONFIGS "DEFAULT") 
    endif()

    message(STATUS "Found build configs:")

    set(DEPS_TO_LINK "")
    foreach(target ${XMOS_TARGETS_LIST})
        target_include_directories(${target} INTERFACE ${APP_INCLUDES})
        target_compile_options(${target} INTERFACE ${APP_COMPILE_FLAGS} ${HEADER_EXIST_FLAGS})
        list(APPEND DEPS_TO_LINK ${target})
    endforeach()
    list(REMOVE_DUPLICATES DEPS_TO_LINK)

    # Setup targets for each build config
    foreach(APP_CONFIG ${APP_CONFIGS})
        message(STATUS ${APP_CONFIG})
        # Check for the "Default" config we created if user didn't specify any configs
        if(${APP_CONFIG} STREQUAL "DEFAULT")
            set(BINARY_NAME  ${PROJECT_NAME})
            set(BINARY_SOURCES ${APP_SOURCES})
            set(BINARY_FLAGS ${APP_COMPILER_FLAGS} ${APP_TARGET_COMPILER_FLAG} ${HEADER_EXISTS_FLAGS})
            set(BINARY_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/bin/")
            set(DOT_BUILD_DIR "${CMAKE_SOURCE_DIR}/.build/")
        else()
            set(BINARY_NAME  ${PROJECT_NAME}_${APP_CONFIG})
            remove_srcs("${APP_CONFIGS}" ${APP_CONFIG} "${APP_SOURCES}" BINARY_SOURCES)
            set(BINARY_FLAGS ${APP_COMPILER_FLAGS_${APP_CONFIG}}  ${APP_TARGET_COMPILER_FLAG} ${HEADER_EXISTS_FLAGS} "-DCONFIG=${APP_CONFIG}")
            set(BINARY_OUTPUT_DIR "${CMAKE_SOURCE_DIR}/bin/${APP_CONFIG}")
            set(DOT_BUILD_DIR "${CMAKE_SOURCE_DIR}/.build_${APP_CONFIG}/")
        endif()

        add_app_file_flags() 
        
        add_executable(${BINARY_NAME})
        
        foreach(target ${XMOS_TARGETS_LIST})
            add_dependencies(${BINARY_NAME} ${target})
        endforeach()

        # TODO do we need the .decouple file scheme? 
        set(PCA_FILES_PATH "")
        file(MAKE_DIRECTORY ${DOT_BUILD_DIR})

        # Run application sources through PCA
        foreach(_file ${BINARY_SOURCES})
            do_pca(${_file} "${BINARY_FLAGS}" ${DOT_BUILD_DIR} file_pca)
            list(APPEND PCA_FILES_PATH ${file_pca})
        endforeach()

        # Interface library sources need to be known at this point, but they aren't resolved until
        # the Generation stage, so populate a list here.
        foreach(target ${XMOS_TARGETS_LIST})
            get_target_property(_tgt_type ${target} TYPE)
            set(pca_lib_sources "")
            if(${_tgt_type} STREQUAL INTERFACE_LIBRARY)
                get_target_property(_tgt_srcs ${target} INTERFACE_SOURCES)
                list(APPEND pca_lib_sources ${_tgt_srcs})
            endif()

            # Run lib sources through PCA 
            get_property(LIB_FLAGS TARGET ${target} PROPERTY INTERFACE_PCA_FLAGS)

            set(LIB_APP_FLAGS ${BINARY_FLAGS} ${LIB_FLAGS})
            foreach(_file ${pca_lib_sources})
                # TODO we would really like to do this in REGISTER_MODULE
                if(LIB_FLAGS)
                    set_source_files_properties(${_file} PROPERTIES COMPILE_OPTIONS "${LIB_FLAGS}")
                endif()
                do_pca(${_file} "${LIB_APP_FLAGS}" ${DOT_BUILD_DIR} file_pca)
                list(APPEND PCA_FILES_PATH ${file_pca})
            endforeach()
        endforeach()
        
        set(DEPS_TO_LINK "")
        set(pca_used_modules "")
        foreach(target ${XMOS_TARGETS_LIST})
            target_include_directories(${target} INTERFACE ${APP_INCLUDES})
            target_compile_options(${target} INTERFACE ${APP_COMPILE_FLAGS})
            list(APPEND DEPS_TO_LINK ${target})
            get_target_property(libtype ${target} TYPE)
            if(${libtype} STREQUAL INTERFACE_LIBRARY)
                list(APPEND pca_used_modules "$<TARGET_PROPERTY:${target},SOURCE_DIR>")
            endif()
        endforeach()
        list(REMOVE_DUPLICATES DEPS_TO_LINK)

        # TODO xcommon uses rsp file for ${PCA_FILES_PATH}
        set(PCA_FILE ${DOT_BUILD_DIR}/pca.xml)
        add_custom_command(
                OUTPUT ${PCA_FILE}
                COMMAND $ENV{XMOS_TOOL_PATH}/libexec/xpca ${PCA_FILE} -deps ${DOT_BUILD_DIR}/pca.d ${DOT_BUILD_DIR} "\"$<1:${pca_used_modules}>\"" ${PCA_FILES_PATH}
                DEPENDS ${PCA_FILES_PATH}
                DEPFILE ${DOT_BUILD_DIR}/pca.d 
                COMMAND_EXPAND_LISTS
            )
        set_property(SOURCE ${PCA_FILE} APPEND PROPERTY OBJECT_DEPENDS ${PCA_FILES_PATH})
      
        set(PCA_FLAG "SHELL: -Xcompiler-xc -analysis" "SHELL: -Xcompiler-xc ${DOT_BUILD_DIR}/pca.xml")

        target_sources(${BINARY_NAME} PRIVATE ${BINARY_SOURCES} ${PCA_FILES_PATH} ${PCA_FILE})
        target_include_directories(${BINARY_NAME} PRIVATE ${APP_INCLUDES})
        target_compile_options(${BINARY_NAME} PRIVATE ${BINARY_FLAGS} ${PCA_FLAG})
        target_link_libraries(${BINARY_NAME} PRIVATE ${DEPS_TO_LINK})
        target_link_options(${BINARY_NAME} PRIVATE ${APP_TARGET_COMPILER_FLAG} ${HEADER_EXISTS_FLAGS})

        # Setup build output
        file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/")
        set_target_properties(${BINARY_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${BINARY_OUTPUT_DIR}")
    endforeach()

endfunction()

## Registers a module and it's dependencies
function(XMOS_REGISTER_MODULE)
    if(ARGC GREATER 0)
        ## Do not output added library message
        string(FIND ${ARGV0} "silent" ${LIB_NAME}_SILENT_FLAG)
        if(${LIB_NAME}_SILENT_FLAG GREATER -1)
            set(${LIB_NAME}_SILENT_FLAG True)
        endif()
    endif()

    set(DEP_MODULE_LIST "")
    if(NOT TARGET ${LIB_NAME})
        if(NOT ${LIB_NAME}_SILENT_FLAG)
            add_library(${LIB_NAME} INTERFACE)
            set_property(TARGET ${LIB_NAME} PROPERTY VERSION ${LIB_VERSION})
        else()
            add_library(${LIB_NAME} OBJECT EXCLUDE_FROM_ALL)
            set_property(TARGET ${LIB_NAME} PROPERTY VERSION ${LIB_VERSION})
        endif()

        set(DEP_OPTIONAL_HEADERS "")
        set(DEP_FILE_FLAGS "")
        foreach(DEP_MODULE ${LIB_DEPENDENT_MODULES})
            string(REGEX MATCH "^[A-Za-z0-9_ -]+" DEP_NAME ${DEP_MODULE})
            string(REGEX REPLACE "^[A-Za-z0-9_ -]+" "" DEP_FULL_REQ ${DEP_MODULE})

            list(APPEND DEP_MODULE_LIST ${DEP_NAME})
            if("${DEP_FULL_REQ}" STREQUAL "")
                message(FATAL_ERROR "Missing dependency version requirement for ${DEP_NAME} in ${LIB_NAME}.\nA version requirement must be specified for all dependencies.")
            endif()

            string(REGEX MATCH "[0-9.]+" VERSION_REQ ${DEP_FULL_REQ} )
            string(REGEX MATCH "[<>=]+" VERSION_QUAL_REQ ${DEP_FULL_REQ} )

            # Add dependencies directories
            if(NOT TARGET ${DEP_NAME})
                if(IS_DIRECTORY ${XMOS_DEPS_ROOT_DIR}/${DEP_NAME}/${DEP_NAME}/lib)
                    include(${XMOS_DEPS_ROOT_DIR}/${DEP_NAME}/${DEP_NAME}/lib/${DEP_NAME}-${APP_BUILD_ARCH}.cmake)
                    get_property(XMOS_TARGETS_LIST GLOBAL PROPERTY XMOS_TARGETS_LIST)
                    set_property(GLOBAL PROPERTY XMOS_TARGETS_LIST "${XMOS_TARGETS_LIST};${DEP_NAME}")
                elseif(EXISTS ${XMOS_DEPS_ROOT_DIR}/${DEP_NAME})
                    add_subdirectory("${XMOS_DEPS_ROOT_DIR}/${DEP_NAME}"  "${CMAKE_BINARY_DIR}/${DEP_NAME}")
                else()
                    message(FATAL_ERROR "Missing dependency ${DEP_NAME}")
                endif()

                get_target_property(${DEP_NAME}_optinc ${DEP_NAME} OPTIONAL_HEADERS)
                list(APPEND DEP_OPTIONAL_HEADERS ${${DEP_NAME}_optinc})
            endif()

            # Check dependency version
            get_target_property(DEP_VERSION ${DEP_NAME} VERSION)

            if(DEP_VERSION VERSION_EQUAL VERSION_REQ)
                string(FIND ${VERSION_QUAL_REQ} "=" DEP_VERSION_CHECK)
            elseif(DEP_VERSION VERSION_LESS VERSION_REQ)
                string(FIND ${VERSION_QUAL_REQ} "<" DEP_VERSION_CHECK)
            elseif(DEP_VERSION VERSION_GREATER VERSION_REQ)
                string(FIND ${VERSION_QUAL_REQ} ">" DEP_VERSION_CHECK)
            endif()

            if(${DEP_VERSION_CHECK} EQUAL "-1")
                message(WARNING "${LIB_NAME} dependency ${DEP_MODULE} not met.  Found ${DEP_NAME}(${DEP_VERSION}).")
            endif()
        endforeach()

        if(NOT ${LIB_NAME}_SILENT_FLAG)
            get_property(XMOS_TARGETS_LIST GLOBAL PROPERTY XMOS_TARGETS_LIST)
            set_property(GLOBAL PROPERTY XMOS_TARGETS_LIST "${XMOS_TARGETS_LIST};${LIB_NAME}")
        endif()

        ## Set optional headers
        if(${LIB_NAME}_DEPS_ONLY_FLAG)
            set(LIB_OPTIONAL_HEADERS ${DEP_OPTIONAL_HEADERS})
        else()
            list(APPEND LIB_OPTIONAL_HEADERS ${DEP_OPTIONAL_HEADERS})
        endif()
        list(REMOVE_DUPLICATES LIB_OPTIONAL_HEADERS)
        list(FILTER LIB_OPTIONAL_HEADERS EXCLUDE REGEX "^.+-NOTFOUND$")
        set_property(TARGET ${LIB_NAME} PROPERTY OPTIONAL_HEADERS ${LIB_OPTIONAL_HEADERS})

        # TODO is this block actually doing anything useful?
        #if(NOT ${LIB_NAME}_SILENT_FLAG)
        #    if("${LIB_ADD_COMPILER_FLAGS}" STREQUAL "")
        #    else()
        #        foreach(file ${LIB_XC_SRCS})
        #            get_filename_component(ABS_PATH ${file} ABSOLUTE)
        #            string(REPLACE ";" " " NEW_FLAGS "${LIB_ADD_COMPILER_FLAGS}")
        #            set_source_files_properties(${ABS_PATH} PROPERTIES COMPILE_FLAGS ${NEW_FLAGS})
        #        endforeach()
        #
        #        foreach(file ${LIB_CXX_SRCS})
        #            get_filename_component(ABS_PATH ${file} ABSOLUTE)
        #            string(REPLACE ";" " " NEW_FLAGS "${LIB_ADD_COMPILER_FLAGS}")
        #            set_source_files_properties(${ABS_PATH} PROPERTIES COMPILE_FLAGS ${NEW_FLAGS})
        #        endforeach()
        #
        #        foreach(file ${LIB_C_SRCS})
        #            get_filename_component(ABS_PATH ${file} ABSOLUTE)
        #            string(REPLACE ";" " " NEW_FLAGS "${LIB_ADD_COMPILER_FLAGS}")
        #            set_source_files_properties(${ABS_PATH} PROPERTIES COMPILE_FLAGS ${NEW_FLAGS})
        #        endforeach()
        #        
        #        foreach(file ${LIB_ASM_SRCS})
        #            get_filename_component(ABS_PATH ${file} ABSOLUTE)
        #            string(REPLACE ";" " " NEW_FLAGS "${LIB_ADD_COMPILER_FLAGS}")
        #            set_source_files_properties(${ABS_PATH} PROPERTIES COMPILE_FLAGS ${NEW_FLAGS})
        #        endforeach()
        #    endif()
        #endif()

        foreach(file ${LIB_ASM_SRCS})
            get_filename_component(ABS_PATH ${file} ABSOLUTE)
            set_source_files_properties(${ABS_PATH} PROPERTIES LANGUAGE ASM)
        endforeach()

        if(NOT ${LIB_NAME}_SILENT_FLAG)
            target_sources(${LIB_NAME} INTERFACE ${LIB_XC_SRCS} ${LIB_CXX_SRCS} ${LIB_ASM_SRCS} ${LIB_C_SRCS})
            target_include_directories(${LIB_NAME} INTERFACE ${LIB_INCLUDES})

            set(DEPS_TO_LINK "")
            foreach(module ${DEP_MODULE_LIST})
                get_target_property(libtype ${module} TYPE)
                if(${libtype} STREQUAL INTERFACE_LIBRARY)
                    list(APPEND DEPS_TO_LINK ${module})
                else()
                    list(APPEND DEPS_TO_LINK "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/lib${module}.a")
                endif()
                add_dependencies(${LIB_NAME} ${module})
            endforeach()

            target_link_libraries(${LIB_NAME} INTERFACE ${DEPS_TO_LINK})
                
            # Cannot do this as options from an interface lib  will propagate to all deps
            #target_compile_options(${LIB_NAME} INTERFACE ${LIB_COMPILER_FLAGS})

            # Instead of the above use a custom property to get the flags to the PCA
            set_property(TARGET ${LIB_NAME} PROPERTY INTERFACE_PCA_FLAGS ${LIB_COMPILER_FLAGS})

            # TODO why cant we do this here? DIRECTORY?
            #get_target_property(_lib_srcs ${LIB_NAME} INTERFACE_SOURCES)
            #foreach(_src_file ${_lib_srcs})
                #set_source_files_properties(${LIB_XC_SRCS} PROPERTIES COMPILE_OPTIONS "${LIB_COMPILER_FLAGS}")
            #endforeach()

            message("Added ${LIB_NAME} (${LIB_VERSION})")
        else()
            target_sources(${LIB_NAME} PUBLIC ${LIB_XC_SRCS} ${LIB_CXX_SRCS} ${LIB_ASM_SRCS} ${LIB_C_SRCS})
            target_include_directories(${LIB_NAME} PRIVATE ${LIB_INCLUDES})
        endif()
    endif()
endfunction()

## Registers a static library target
function(XMOS_STATIC_LIBRARY)
    list(LENGTH LIB_ARCH num_arch)
    if(${num_arch} LESS 1)
        # If architecture not specified, assume xs3a
        set(LIB_ARCH "xs3a")
    endif()

    foreach(lib_arch ${LIB_ARCH})
        add_library(${LIB_NAME}-${lib_arch} STATIC)
        set_property(TARGET ${LIB_NAME}-${lib_arch} PROPERTY VERSION ${LIB_VERSION})
        target_sources(${LIB_NAME}-${lib_arch} PRIVATE ${LIB_XC_SRCS} ${LIB_CXX_SRCS} ${LIB_ASM_SRC} ${LIB_C_SRCS})
        target_include_directories(${LIB_NAME}-${lib_arch} PRIVATE ${LIB_INCLUDES})
        target_compile_options(${LIB_NAME}-${lib_arch} PUBLIC ${LIB_ADD_COMPILER_FLAGS} "-march=${lib_arch}")

        set_property(TARGET ${LIB_NAME}-${lib_arch} PROPERTY ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib/${lib_arch})
        # Set output name so that static library filename does not include architecture
        set_property(TARGET ${LIB_NAME}-${lib_arch} PROPERTY ARCHIVE_OUTPUT_NAME ${LIB_NAME})
    endforeach()

    set(DEP_MODULE_LIST "")
    foreach(DEP_MODULE ${LIB_DEPENDENT_MODULES})
        string(REGEX MATCH "^[A-Za-z0-9_ -]+" DEP_NAME ${DEP_MODULE})
        string(REGEX REPLACE "^[A-Za-z0-9_ -]+" "" DEP_FULL_REQ ${DEP_MODULE})

        list(APPEND DEP_MODULE_LIST ${DEP_NAME})
        if("${DEP_FULL_REQ}" STREQUAL "")
            message(FATAL_ERROR "Missing dependency version requirement for ${DEP_NAME} in ${LIB_NAME}.\nA version requirement must be specified for all dependencies.")
        endif()

        string(REGEX MATCH "[0-9.]+" VERSION_REQ ${DEP_FULL_REQ} )
        string(REGEX MATCH "[<>=]+" VERSION_QUAL_REQ ${DEP_FULL_REQ} )

        # Add dependencies directories
        if(NOT TARGET ${DEP_NAME})
            if(EXISTS ${XMOS_DEPS_ROOT_DIR}/${DEP_NAME})
                add_subdirectory("${XMOS_DEPS_ROOT_DIR}/${DEP_NAME}"  "${CMAKE_BINARY_DIR}/${DEP_NAME}")
            else()
                message(FATAL_ERROR "Missing dependency ${DEP_NAME}")
            endif()
        endif()

        # Check dependency version
        get_target_property(DEP_VERSION ${DEP_NAME} VERSION)

        if(DEP_VERSION VERSION_EQUAL VERSION_REQ)
            string(FIND ${VERSION_QUAL_REQ} "=" DEP_VERSION_CHECK)
        elseif(DEP_VERSION VERSION_LESS VERSION_REQ)
            string(FIND ${VERSION_QUAL_REQ} "<" DEP_VERSION_CHECK)
        elseif(DEP_VERSION VERSION_GREATER VERSION_REQ)
            string(FIND ${VERSION_QUAL_REQ} ">" DEP_VERSION_CHECK)
        endif()

        if(${DEP_VERSION_CHECK} EQUAL "-1")
            message(WARNING "${LIB_NAME} dependency ${DEP_MODULE} not met.  Found ${DEP_NAME}(${DEP_VERSION}).")
        endif()
    endforeach()

    foreach(lib_arch ${LIB_ARCH})
        target_link_libraries(${LIB_NAME}-${lib_arch} PRIVATE ${DEP_MODULE_LIST})

        # To statically link this library into an application, a cmake file is needed which will be included in
        # other projects to access this library. Start with a template file with exactly the content written by
        # the file() command below; no variables are substituted.
        file(WRITE ${CMAKE_BINARY_DIR}/${LIB_NAME}-${lib_arch}.cmake.in [=[
            add_library(@LIB_NAME@ STATIC IMPORTED)
            set_property(TARGET @LIB_NAME@ PROPERTY IMPORTED_LOCATION ${XMOS_DEPS_ROOT_DIR}/@LIB_NAME@/@LIB_NAME@/lib/@lib_arch@/lib@LIB_NAME@.a)
            set_property(TARGET @LIB_NAME@ PROPERTY VERSION @LIB_VERSION@)
            foreach(incdir @LIB_INCLUDES@)
                target_include_directories(@LIB_NAME@ INTERFACE ${XMOS_DEPS_ROOT_DIR}/@LIB_NAME@/@LIB_NAME@/${incdir})
            endforeach()
        ]=])

        # Produce the final cmake include file by substituting variables surrounded by @ signs in the template
        configure_file(${CMAKE_BINARY_DIR}/${LIB_NAME}-${lib_arch}.cmake.in ${XMOS_DEPS_ROOT_DIR}/${LIB_NAME}/${LIB_NAME}/lib/${LIB_NAME}-${lib_arch}.cmake @ONLY)
    endforeach()
endfunction()
