cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(native_build)

set(APP_DEPENDENT_MODULES lib_static0)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
