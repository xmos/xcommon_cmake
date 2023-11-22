cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(generated_source_file)

set(APP_HW_TARGET XCORE-AI-EXPLORER)

XMOS_REGISTER_APP()

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/generated)
add_custom_target(foo.c
                  ${CMAKE_COMMAND} -E echo \"void foo() {}\" > ${CMAKE_BINARY_DIR}/generated/foo.c
                  BYPRODUCTS ${CMAKE_BINARY_DIR}/generated/foo.c
                  )
target_sources(generated_source_file PRIVATE ${CMAKE_BINARY_DIR}/generated/foo.c)
