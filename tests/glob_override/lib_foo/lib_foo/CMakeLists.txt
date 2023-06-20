set(LIB_NAME "lib_foo")
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS "src/foo.xc" "src/src0/foo0.xc")
set(LIB_C_SRCS "src/src1/foo1.c")
set(LIB_CXX_SRCS "src/src1/foo1.cpp")
set(LIB_ASM_SRCS "src/src0/foo0.S")
set(LIB_INCLUDES "api")
set(LIB_DEPENDENT_MODULES "")
set(LIB_EXPORT_SOURCE_DIRS "api")

set(XMOS_DEPS_ROOT_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_STATIC_LIBRARY()
