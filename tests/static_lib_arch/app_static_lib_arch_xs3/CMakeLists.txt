cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(static_lib_xs3a)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_static0)

set(APP_ARCHIVES archive_xs3)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
