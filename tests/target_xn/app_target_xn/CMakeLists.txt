cmake_minimum_required(VERSION 3.21)

## Import XMOS configurations
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)

set(CMAKE_VERBOSE_MAKEFILE ON)

## Define project
project(target_xn)

## Set hardware target
set(APP_HW_TARGET "xk-audio-316-mc.xn")

## Register the application
XMOS_REGISTER_APP()
