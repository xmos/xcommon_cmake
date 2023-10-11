cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(xscope_glob)

set(APP_HW_TARGET XCORE-AI-EXPLORER)

XMOS_REGISTER_APP()
