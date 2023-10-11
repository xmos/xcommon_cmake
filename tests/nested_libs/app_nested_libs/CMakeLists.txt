cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(nested_libs)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_intf0 lib_stat0)

set(XMOS_DEPS_ROOT_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
