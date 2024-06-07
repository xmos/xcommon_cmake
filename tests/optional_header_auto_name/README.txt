Application source contains some optional header files to test different scenarios
with the dependent modules:
- lib_mod0: expects both the automatic optional header, and a second which is
  specified in lib_build_info.cmake
- lib_mod1: expects the automatic optional header which has also been specified
  in lib_build_info.cmake
- lib_mod2: expects the automatic optional header which is not listed in
  lib_build_info.cmake
- lib_mod3: expects the absence of the automatic optional header which is not
  listed in lib_build_info.cmake
