cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(pca_libs)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(APP_XC_SRCS src/pca_libs.xc)
set(APP_DEPENDENT_MODULES lib_foo lib_bar)
set(APP_PCA_ENABLE ON)

set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_REGISTER_APP()
