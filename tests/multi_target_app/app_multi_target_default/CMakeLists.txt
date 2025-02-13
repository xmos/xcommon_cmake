cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(multi_target_default)

set(APP_HW_TARGET XK-EVK-XU316)

set(APP_HW_TARGET_xs2 XCORE-200-EXPLORER)

# Set flags to create xs2 and xs3 configs
set(COMMON_FLAGS -g -O2)
set(APP_COMPILER_FLAGS_xs2 ${COMMON_FLAGS})
set(APP_COMPILER_FLAGS_xs3 ${COMMON_FLAGS})

XMOS_REGISTER_APP()
