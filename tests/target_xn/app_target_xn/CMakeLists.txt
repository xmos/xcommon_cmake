cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(target_xn)

set(APP_HW_TARGET xk-audio-316-mc.xn)

XMOS_REGISTER_APP()
