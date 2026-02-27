Tests that LIB_LINKER_FLAGS are propagated as target_link_options of the app.

The various libraries that are the app's APP_DEPENDENT_MODULES set various linker options
through set(LIB_LINKER_FLAGS ...)
The test compiles the app and checks various things to ensure that the options did get added
to the app's target_link_options.

The linker options added as -report, -Wm,--map,test_linker_flags.map and -v
-report is checked by ensuring that the make command stdout has "Constraint check for tile[0]" string.
-Wm,--map,test_linker_flags.map is checked by checking if the map file test_linker_flags.map exists.
-v (verbose) is checked by checking if the "xmap --defsymbol" is present in the make stdout
