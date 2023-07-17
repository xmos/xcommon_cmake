set(LIB_NAME lib_foo)
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS src/foo.xc)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES lib_bar)

XMOS_REGISTER_MODULE()
