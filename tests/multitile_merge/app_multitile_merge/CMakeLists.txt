cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(multitile_merge)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_MULTITILE_MERGE 2)

XMOS_REGISTER_APP()
