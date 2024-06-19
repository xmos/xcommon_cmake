set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

### Items for building archives contained in this lib

# Specify archives "configs" we want to produce
set(LIB_ARCHIVES static0_archive0 static0_archive1)

# For each "config" specify architectures supported
set(LIB_ARCHIVE_ARCHS_static0_archive0 xs2a xs3a)
set(LIB_ARCHIVE_ARCHS_static0_archive1 xs3a)

# For each archive "config" provide some options that apply to building the .a
set(LIB_ARCHIVE_FLAGS_static0_archive0 -DLIB_STATIC0_OPTION_archive0=1)
set(LIB_ARCHIVE_FLAGS_static0_archive1 -DLIB_STATIC0_OPTION_archive1=1)

set(LIB_ARCHIVE_DEPENDENT_MODULES "")

# Specify includes for building archives
set(LIB_ARCHIVE_INCLUDES inc)

### Items to allow use of this lib (contained archives and additonal source files)

# Applies to the additional source files
set(LIB_COMPILER_FLAGS -DLIB_STATIC0_OPTION=1)

# Includes for libs/apps using this lib
set(LIB_INCLUDES api)

XMOS_REGISTER_STATIC_LIB()
