cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(file_specific_flags)

set(APP_HW_TARGET XCORE-AI-EXPLORER)

# Note, unlike the original xcommon the file specific flags will not be completely over-written for the
# files listed below but instead, appended to the end of APP_COMPILER_FLAGS
set(APP_COMPILER_FLAGS -DFLAG0=0)

set(APP_COMPILER_FLAGS_test.xc -UFLAG0 -DFLAG1=1)
set(APP_COMPILER_FLAGS_flag2.c -DFLAG2=2)
set(APP_COMPILER_FLAGS_flag3.cpp -DFLAG3=3)
set(APP_COMPILER_FLAGS_flag4.S -DFLAG4=4)

XMOS_REGISTER_APP()
