cmake_minimum_required(VERSION 3.21)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_SOURCE_DIR})
    include("$ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake")
    project("lib_foo")
endif()

add_subdirectory("lib_foo")
