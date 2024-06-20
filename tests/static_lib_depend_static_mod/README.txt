Sourcelibray is used as a dependency by a static library

i.e. lib_static0 <- lib_mod0

We expect the archive(s) of lib_static0 to include items from lib_mod0

TODO check mod0() ends up in static0_archive.a (and not in the general
sources)
