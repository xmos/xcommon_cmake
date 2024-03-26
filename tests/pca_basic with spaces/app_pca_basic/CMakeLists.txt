cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(pca_basic)

set(APP_HW_TARGET "XCORE-AI-EXPLORER")
set(APP_XC_SRCS src/pca_basic.xc)
set(APP_PCA_ENABLE ON)

XMOS_REGISTER_APP()
