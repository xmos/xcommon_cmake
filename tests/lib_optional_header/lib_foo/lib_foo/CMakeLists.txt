set(LIB_NAME "lib_foo")
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS "src/foo.xc")
# "src" in LIB_INCLUDES as it provides bar_conf.h optional header for lib_bar
set(LIB_INCLUDES "api" "src")
set(LIB_DEPENDENT_MODULES "lib_bar(>=1.0.0)")
set(LIB_OPTIONAL_HEADERS "")

set(XMOS_DEPS_ROOT_DIR "${CMAKE_SOURCE_DIR}/..")

XMOS_REGISTER_MODULE()
