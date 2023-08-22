cmake_minimum_required(VERSION 3.14)

include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)

project(fetch_deps)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES "danielpieczko/lib_test0(1.0.0)")

set(XMOS_DEPS_ROOT_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
