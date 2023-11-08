cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(unit_repeated_include_xcommon)

# It should be possible to repeat this include after the project() call without any errors
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)

# It should be possible to repeat the include from within a subdirectory
add_subdirectory(dir0)
