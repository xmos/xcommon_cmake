set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

set(LIB_ADD_SRC_DIRS src)
set(LIB_ADD_INC_DIRS inc)

set(LIB_ARCHIVES archive_xs3 archive_xs2)

set(LIB_ARCHIVE_ARCH_archive_xs3 xs3a
set(LIB_ARCHIVE_ARCH_archive_xs2 xs2a

# Applies to building the .a
set(LIB_ARCHIVE_FLAGS_archive_xs2 -DLIB_STATIC0_OPTION_archive_xs3=1)
set(LIB_ARCHIVE_FLAGS_archive_xs3 -DLIB_STATIC0_OPTION_archive_xs2=1)

# Applies to the additional source files
set(LIB_COMPILER_FLAGS -DLIB_STATIC0_OPTION=1)

XMOS_REGISTER_STATIC_LIB()
