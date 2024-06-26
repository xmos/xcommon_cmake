set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

### Items for building archives contained in this lib

# Specify "configs" for the archives we want to build
set(LIB_ARCHIVES static0_archive)

# For each "config" specify the architecures to build archives for
set(LIB_ARCHIVE_ARCHS_static0_archive xs3a)

# Dependencies for building the archives
set(LIB_ARCHIVE_DEPENDENT_MODULES "")

# Includes for building archive(s)
set(LIB_ARCHIVE_INCLUDES api)

# Archive sources (default is to glob in libsrc)
set(LIB_ARCHIVE_XC_SRCS mylibsrc/static0_archive.xc mylibsrc/srcA/static0A_archive.xc)
set(LIB_ARCHIVE_C_SRCS mylibsrc/srcB/static0B_archive.c)
set(LIB_ARCHIVE_CXX_SRCS mylibsrc/srcB/static0B_archive.cpp)

### Items to allow use of this lib (contained archives and additonal source files)

# "Additional" sources (default is to glob in src)
set(LIB_XC_SRCS mysrc/static0.xc mysrc/srcA/static0A.xc)
set(LIB_C_SRCS mysrc/srcB/static0B.c)
set(LIB_CXX_SRCS mysrc/srcB/static0B.cpp)

# Include directories to expose to dependent libs/apps
set(LIB_INCLUDES api)

XMOS_REGISTER_STATIC_LIB()

