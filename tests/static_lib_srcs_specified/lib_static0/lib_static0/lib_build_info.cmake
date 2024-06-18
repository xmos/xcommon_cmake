set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

set(LIB_ARCHIVES static0_archive)
set(LIB_ARCHIVE_ARCHS_static0_archive xs3a)

set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

# Includes for building archive(s)
set(LIB_ARCHIVE_INCLUDES inc api)

# "Additional" sources (default is to glob in src)
set(LIB_XC_SRCS mysrc/mod0.xc mysrc/srcA/mod0A.xc)
set(LIB_C_SRCS mysrc/srcB/mod0B.c)
set(LIB_CXX_SRCS mysrc/srcB/mod0B.cpp)

# Archive sources (default is to glob in libsrc)
set(LIB_ARCHIVE_XC_SRCS mylibsrc/mod0.xc mylibsrc/srcA/static0A.xc)
set(LIB_ARCHIVE_C_SRCS mylivsrc/srcB/static0B.c)
set(LIB_ARCHIVE_CXX_SRCS mylibsrc/srcB/static0B.cpp)

XMOS_REGISTER_STATIC_LIB()
