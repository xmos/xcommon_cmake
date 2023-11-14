cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(lib_file_specific_flags)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES lib_intf)
set(APP_COMPILER_FLAGS -DAPP_OPTION=1)

set(XMOS_SANDBOX_DIR "${CMAKE_SOURCE_DIR}/..")

XMOS_REGISTER_APP()
