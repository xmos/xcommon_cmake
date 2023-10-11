cmake_minimum_required(VERSION 3.21)

include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)

project(file_specific_flags_configs)

# Note, this will be set in XMOS SetupEnv
if(NOT DEFINED ENV{XMOS_CMAKE_PATH})
    message(ERROR "XMOS_CMAKE_PATH not defined")
else()
    message(STATUS "Using cmake scripts from $ENV{XMOS_CMAKE_PATH}")
endif()

## Set XMOS application variables
set(APP_HW_TARGET "XCORE-AI-EXPLORER")

#Note, unlike xcommon this will not be completely overidden in the files listed below
#but appended to the end of the flags
set(APP_COMPILER_FLAGS_config1 "-DMSG=Config1")
set(APP_COMPILER_FLAGS_config2 "-DMSG=Config2")

set(APP_COMPILER_FLAGS_test.xc "-DFLAG1=1")
set(APP_COMPILER_FLAGS_flag2.c "-DFLAG2=2")
set(APP_COMPILER_FLAGS_flag3.cpp "-DFLAG3=3")
set(APP_COMPILER_FLAGS_flag4.S "-DFLAG4=4")

XMOS_REGISTER_APP()
