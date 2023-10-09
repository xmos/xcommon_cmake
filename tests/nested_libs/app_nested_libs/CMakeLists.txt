cmake_minimum_required(VERSION 3.21)

include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")

project(nested_libs)

# Note, this will be set in XMOS SetupEnv
if(NOT DEFINED ENV{XMOS_CMAKE_PATH})
    message(ERROR "XMOS_CMAKE_PATH not defined")
else()
    message(STATUS "Using cmake scripts from $ENV{XMOS_CMAKE_PATH}")
endif()

## Set XMOS application variables
set(APP_HW_TARGET "XCORE-AI-EXPLORER")

set(APP_DEPENDENT_MODULES "intf0" "stat0")

set(XMOS_DEPS_ROOT_DIR "${CMAKE_SOURCE_DIR}/..")

XMOS_REGISTER_APP()
