cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(dep_location)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_foo lib_bar)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

set(XMOS_DEP_DIR_lib_foo ${CMAKE_SOURCE_DIR}/deps/lib_foo)
set(XMOS_DEP_DIR_lib_bar ${CMAKE_SOURCE_DIR}/deps/lib_bar)

XMOS_REGISTER_APP()
