cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(optional_header_auto_name)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES "lib_mod0"
                          "lib_mod1"
                          "lib_mod2"
                          "lib_mod3")

# "src" directory in APP_INCLUDES because optional header is there
set(APP_INCLUDES src)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
