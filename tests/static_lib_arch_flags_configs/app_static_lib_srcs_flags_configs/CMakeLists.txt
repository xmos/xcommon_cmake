cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(static_lib_srcs_flags_configs)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_DEPENDENT_MODULES "lib_static0" "lib_static1")

# Add src to include directory search path for optional header
set(APP_INCLUDES src)

# Define some build configs for the app
set(APP_COMPILER_FLAGS_config0 -DMSG=config0)
set(APP_COMPILER_FLAGS_config1 -DMSG=config1)

# Choose which archive we want to use for each config
set(APP_DEPENDENT_ARCHIVES_config0 static0_archive0 static1)
set(APP_DEPENDENT_ARCHIVES_config1 static0_archive1 static1)

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/..)

XMOS_REGISTER_APP()
