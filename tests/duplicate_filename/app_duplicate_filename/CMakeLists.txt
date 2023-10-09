cmake_minimum_required(VERSION 3.21)

include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")

project(duplicate_filename)

## Set XMOS application variables
set(APP_HW_TARGET "XCORE-AI-EXPLORER")

set(APP_DEPENDENT_MODULES "lib_intf(>=1.0.0)" "lib_intf2(>=1.0.0)")

set(XMOS_DEPS_ROOT_DIR "${CMAKE_SOURCE_DIR}/..")

XMOS_REGISTER_APP()
