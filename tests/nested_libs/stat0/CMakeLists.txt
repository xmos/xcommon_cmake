cmake_minimum_required(VERSION 3.14)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
    include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")
    project("stat0")
endif()

set(LIB_NAME "stat0")
set(LIB_VERSION 1.0.0)
set(LIB_XC_SRCS "src/stat0.xc")
set(LIB_INCLUDES "api")
set(LIB_DEPENDENT_MODULES "intf2(>=1.0.0)")
set(LIB_EXPORT_SOURCE_DIRS "api")

set(XMOS_DEPS_ROOT_DIR ${CMAKE_SOURCE_DIR}/..)

XMOS_STATIC_LIBRARY()
