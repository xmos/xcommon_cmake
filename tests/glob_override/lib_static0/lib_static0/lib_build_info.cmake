set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS libsrc/static0.xc libsrc/srcA/static0A.xc)
set(LIB_C_SRCS libsrc/srcB/static0B.c)
set(LIB_CXX_SRCS libsrc/srcB/static0B.cpp)
set(LIB_ASM_SRCS libsrc/srcA/static0A.S)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

XMOS_REGISTER_STATIC_LIB()
