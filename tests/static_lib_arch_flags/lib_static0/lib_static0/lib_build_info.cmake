set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

set(LIB_ADD_SRC_DIRS src)
set(LIB_ADD_INC_DIRS inc)

# Specify archives "configs" we want to produce
set(LIB_ARCHIVES static0_archive0 static0_archive1)

# For each "config" specify architectures supported
set(LIB_ARCHIVE_ARCHS_static0_archive0 xs2a xs3a)
set(LIB_ARCHIVE_ARCHS_static0_archive1 xs3a)

# For each archive "config" provide some options that apply to building the .a
set(LIB_ARCHIVE_FLAGS_static0_archive0 -DLIB_STATIC0_OPTION_archive0=1)
set(LIB_ARCHIVE_FLAGS_static0_archive1 -DLIB_STATIC0_OPTION_archive1=1)

# Applies to the additional source files
set(LIB_COMPILER_FLAGS -DLIB_STATIC0_OPTION=1)

XMOS_REGISTER_STATIC_LIB()
