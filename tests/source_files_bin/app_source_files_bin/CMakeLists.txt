cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(source_files_bin)

set(APP_HW_TARGET XCORE-AI-EXPLORER)

set(APP_COMPILER_FLAGS_config1 -DMSG=config1 -DCFG=1)
set(APP_COMPILER_FLAGS_config2 -DMSG=config2 -DCFG=2)
set(APP_COMPILER_FLAGS_config3 -DMSG=config3 -DCFG=3)

set(SOURCE_FILES_config1 config1.xc config1a.xc)
set(SOURCE_FILES_config2 config2.xc)

XMOS_REGISTER_APP()
