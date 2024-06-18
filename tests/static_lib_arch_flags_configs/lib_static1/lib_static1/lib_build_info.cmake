set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

set(LIB_ADD_SRC_DIRS src)
set(LIB_ADD_INC_DIRS inc)

# Specify architectures to build archives for
set(LIB_ARCHIVE_ARCHS xs2a xs3a)

# Provide some options that apply to building the .a
set(LIB_ARCHIVE_FLAGS -DLIB_STATIC0_OPTION_archive=1)

# Applies to the additional source files
set(LIB_COMPILER_FLAGS -DLIB_STATIC1_OPTION=1)

XMOS_REGISTER_STATIC_LIB()
