cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(hello)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_XC_SRCS src/hello.xc)

XMOS_REGISTER_APP()
