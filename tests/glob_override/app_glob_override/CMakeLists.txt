cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(glob_override)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_foo lib_bar)

set(APP_XC_SRCS src/main.xc src/src0/src0.xc)
set(APP_CXX_SRCS src/src1/src1.cpp)
# Empty list here so no C source files are compiled
set(APP_C_SRCS "")
set(APP_ASM_SRCS src/src0/src0.S)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
