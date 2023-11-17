cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(dep_location)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_mod0 lib_static0)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

set(XMOS_DEP_DIR_lib_mod0 ${CMAKE_SOURCE_DIR}/deps/lib_mod0)
set(XMOS_DEP_DIR_lib_static0 ${CMAKE_SOURCE_DIR}/deps/lib_static0)

XMOS_REGISTER_APP()
