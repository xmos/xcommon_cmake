set(LIB_NAME lib_intf)
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS src/intf.xc)
set(LIB_ASM_SRCS src/intf.S)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

XMOS_REGISTER_MODULE()
