cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(lib_generated_source_file)

set(APP_HW_TARGET XCORE-AI-EXPLORER)

set(APP_COMPILER_FLAGS_cfg0 -Os)
set(APP_COMPILER_FLAGS_cfg1 -O3)

set(APP_DEPENDENT_MODULES "lib_mod0")

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

XMOS_REGISTER_APP()
