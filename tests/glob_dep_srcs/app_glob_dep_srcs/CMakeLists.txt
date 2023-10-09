cmake_minimum_required(VERSION 3.21)

include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)

project(glob_dep_srcs)

if(NOT DEFINED ENV{XMOS_CMAKE_PATH})
    message(ERROR "XMOS_CMAKE_PATH not defined")
else()
    message(STATUS "Using cmake scripts from $ENV{XMOS_CMAKE_PATH}")
endif()

set(APP_HW_TARGET XCORE-AI-EXPLORER)

set(APP_DEPENDENT_MODULES lib_foo)

set(XMOS_DEPS_ROOT_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
