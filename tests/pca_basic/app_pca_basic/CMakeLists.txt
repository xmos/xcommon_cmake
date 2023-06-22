cmake_minimum_required(VERSION 3.14)

# Note, this will be set in XMOS SetupEnv
if(NOT DEFINED ENV{XMOS_CMAKE_PATH})
    message(ERROR "XMOS_CMAKE_PATH not defined")
else()
    message(STATUS "Using cmake scripts from $ENV{XMOS_CMAKE_PATH}")
endif()

## Import XMOS configurations
include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")

## Define project
project(pca_basic)

set(APP_XC_SRCS
        "src/pca_basic.xc"
    )

set(APP_HW_TARGET "XCORE-AI-EXPLORER")

set(CMAKE_VERBOSE_MAKEFILE ON)

## Register the application
XMOS_REGISTER_APP()
