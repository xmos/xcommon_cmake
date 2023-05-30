set(LIB_NAME "intf0")
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS "src/intf0.xc")
set(LIB_INCLUDES "api")
set(LIB_DEPENDENT_MODULES "intf1(>=1.0.0)")

XMOS_REGISTER_MODULE()
