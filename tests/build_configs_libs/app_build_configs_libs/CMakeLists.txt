cmake_minimum_required(VERSION 3.21)

include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")

project(build_configs_libs)

## Set XMOS application variables
set(APP_HW_TARGET "XCORE-AI-EXPLORER")


set(APP_COMPILER_FLAGS "-DMSG=ERROR") # We expect this to be ignored
set(APP_COMPILER_FLAGS_config2 "-DMSG=config2")
set(APP_COMPILER_FLAGS_config1 "-DMSG=config1")
set(APP_DEPENDENT_MODULES "lib_intf(>=1.0.0)" "lib_stat(>=1.0.0)")

set(XMOS_DEPS_ROOT_DIR "${CMAKE_SOURCE_DIR}/..")

XMOS_REGISTER_APP()
