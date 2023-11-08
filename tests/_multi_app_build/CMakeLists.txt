cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(multi_app_build)

add_subdirectory(app_foo)
add_subdirectory(app_bar)
