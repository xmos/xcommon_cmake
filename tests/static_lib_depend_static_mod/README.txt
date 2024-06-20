Source library lib_mod0 is used as a dependency by a static library, lib_static0

i.e. lib_static0 <- lib_mod0

Note, we expect the archive(s) of lib_static0 to include items from lib_mod0

TODO check mod0() ends up in static0_archive.a (and not in the general
sources)
