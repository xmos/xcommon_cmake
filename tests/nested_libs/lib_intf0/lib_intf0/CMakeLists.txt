set(LIB_NAME lib_intf0)
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS src/intf0.xc)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES lib_intf1)

XMOS_REGISTER_MODULE()
