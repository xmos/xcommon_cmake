cmake_minimum_required(VERSION 3.13)
project(test_hello)
add_executable(a src/hello.xc)
target_link_options(a PRIVATE "-target=XCORE-AI-EXPLORER")
