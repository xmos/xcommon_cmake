set(LIB_NAME "lib_lib2")
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS "src/lib2.xc")
set(LIB_INCLUDES "api")
set(LIB_DEPENDENT_MODULES "lib_lib0(>=1.0.0)")

XMOS_REGISTER_MODULE()
