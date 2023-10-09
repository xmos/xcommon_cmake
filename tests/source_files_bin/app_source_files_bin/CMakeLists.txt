cmake_minimum_required(VERSION 3.21)
#set(CMAKE_VERBOSE_MAKEFILE ON)

include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")

project(source_files_bin)

# Note, this will be set in XMOS SetupEnv
if(NOT DEFINED ENV{XMOS_CMAKE_PATH})
    message(ERROR "XMOS_CMAKE_PATH not defined")
else()
    message(STATUS "Using cmake scripts from $ENV{XMOS_CMAKE_PATH}")
endif()

## Set XMOS application variables
set(APP_HW_TARGET "XCORE-AI-EXPLORER")

set(APP_COMPILER_FLAGS_config1 "-DMSG=config1" "-DCFG=1")
set(APP_COMPILER_FLAGS_config2 "-DMSG=config2" "-DCFG=2")
set(APP_COMPILER_FLAGS_config3 "-DMSG=config3" "-DCFG=3")

set(SOURCE_FILES_config1 "config1.xc" "config1a.xc")
set(SOURCE_FILES_config2 "config2.xc")

XMOS_REGISTER_APP()
