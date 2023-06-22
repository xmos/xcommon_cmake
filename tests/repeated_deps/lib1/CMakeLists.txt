set(LIB_NAME "lib1")
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS "src/lib1.xc")
set(LIB_INCLUDES "api")
set(LIB_DEPENDENT_MODULES "lib0(>=1.0.0)")

XMOS_REGISTER_MODULE()
