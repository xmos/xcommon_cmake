set(LIB_NAME lib_mod0)
set(LIB_VERSION 1.0.0)
# "src" in LIB_INCLUDES as it provides mod1_conf.h optional header for lib_mod1
set(LIB_INCLUDES api src)
set(LIB_DEPENDENT_MODULES lib_mod1)
set(LIB_OPTIONAL_HEADERS "")

XMOS_REGISTER_MODULE()
