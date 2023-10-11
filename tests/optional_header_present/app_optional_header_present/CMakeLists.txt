cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(optional_header_present)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_foo)

# "src" directory in APP_INCLUDES because optional header is there
set(APP_INCLUDES src)

set(XMOS_DEPS_ROOT_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
