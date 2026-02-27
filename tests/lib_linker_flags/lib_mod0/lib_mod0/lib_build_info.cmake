set(LIB_NAME lib_mod0)
set(LIB_VERSION 1.0.0)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")
set(LIB_LINKER_FLAGS "-Wm,--map,test_linker_flags.map")

XMOS_REGISTER_MODULE()
