cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(build_configs)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_COMPILER_FLAGS -DMSG=ERROR) # We expect this to be ignored
set(APP_COMPILER_FLAGS_config2 -DMSG=config2)
set(APP_COMPILER_FLAGS_config1 -DMSG=config1)

XMOS_REGISTER_APP()
