cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(static_lib_unnamed_xs2a)

set(APP_HW_TARGET XCORE-200-EXPLORER)
set(APP_DEPENDENT_MODULES lib_static0)

# We shouldn't need to select which flavour archive of lib_static0 we want to use since there arn't
# any (other than for archs)
# If this is not easily achieved then we add this line (which makes this test match static_lib_arch)
#set(APP_DEPENDENT_ARCHIVES static0_archive)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
