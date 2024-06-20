cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(static_lib_srcs_flags_archive0_xs3)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES "lib_static0")

# Add src to include directory search path for optional header
set(APP_INCLUDES src)

# Choose which archive we want to use
set(APP_DEPENDENT_ARCHIVES static0_archive0)

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

XMOS_REGISTER_APP()
