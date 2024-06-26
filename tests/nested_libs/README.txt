Application that tests nested library dependencies:
 - app requires lib_mod0 and lib_static0
 - lib_mod0 requires lib_mod1
 - lib_static0 is compiled as a static library
 - lib_static0 requires lib_mod2
 - lib_mod2 requires lib_mod3

 Note, this test doesn't include a lib_mod that depends on a lib_static. See
 static_lib_depend for a separate test for this.
