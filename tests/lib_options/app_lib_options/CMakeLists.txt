cmake_minimum_required(VERSION 3.14)

include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")

project(lib_options)

## Set XMOS application variables
set(APP_HW_TARGET "XCORE-AI-EXPLORER")
set(APP_DEPENDENT_MODULES "lib_intf(>=1.0.0)" "lib_stat(>=1.0.0)")
set(APP_COMPILER_FLAGS "-DAPP_OPTION=1")

set(XMOS_DEPS_ROOT_DIR "${CMAKE_SOURCE_DIR}/..")
XMOS_REGISTER_APP()
