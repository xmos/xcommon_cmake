cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(app_rep_deps0)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_mod0 lib_mod1)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
