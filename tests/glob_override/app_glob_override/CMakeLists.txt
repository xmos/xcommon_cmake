cmake_minimum_required(VERSION 3.21)

# Note, this will be set in XMOS SetupEnv
if(NOT DEFINED ENV{XMOS_CMAKE_PATH})
    message(ERROR "XMOS_CMAKE_PATH not defined")
else()
    message(STATUS "Using cmake scripts from $ENV{XMOS_CMAKE_PATH}")
endif()

## Import XMOS configurations
include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")

set(CMAKE_VERBOSE_MAKEFILE ON)

## Define project
project(glob_override)

enable_language(CXX C ASM)

set(APP_XC_SRCS
        "src/main.xc"
        "src/src0/src0.xc"
)

set(APP_CXX_SRCS
        "src/src1/src1.cpp"
)

# Empty list here so no C source files are compiled
set(APP_C_SRCS "")

set(APP_ASM_SRCS
        "src/src0/src0.S"
)

set(APP_HW_TARGET "XCORE-AI-EXPLORER")

set(APP_DEPENDENT_MODULES "lib_foo" "lib_bar")

set(XMOS_DEPS_ROOT_DIR ${CMAKE_SOURCE_DIR}/..)

## Register the application
XMOS_REGISTER_APP()
