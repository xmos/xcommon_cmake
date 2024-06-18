set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

set(LIB_INCLUDES inc)

set(LIB_ARCHIVES static0_archive)

set(LIB_ARCHIVE_ARCHS_static0_archive xs2a xs3a)

# Applies to building the .a
set(LIB_ARCHIVE_FLAGS_static0_archive -DLIB_STATIC0_OPTION_archive=1)

# Applies to the additional source files
set(LIB_COMPILER_FLAGS -DLIB_STATIC0_OPTION=1)

XMOS_REGISTER_STATIC_LIB()
