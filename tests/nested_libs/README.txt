Application that tests nested library dependencies:
 - app requires lib_mod0 and lib_static0
 - lib_mod0 requires lib_mod1
 - lib_static0 is compiled as a static library
 - lib_static0 requires lib_mod2
 - lib_mod2 requires lib_mod3
