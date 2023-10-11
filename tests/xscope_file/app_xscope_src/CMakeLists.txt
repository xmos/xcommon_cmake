cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(xscope_src)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_XSCOPE_SRCS src/config.xscope)

XMOS_REGISTER_APP()
