set(LIB_NAME lib_intf2)
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS src/intf2.xc)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES lib_intf3)

XMOS_REGISTER_MODULE()
