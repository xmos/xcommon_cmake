Application uses module lib_mod0, which has a source file that is generated in the build directory before
being compiled and linked. Two configs are created to check that APP_BUILD_TARGETS is correctly used as a
list in lib_mod0's lib_build_info.cmake.
