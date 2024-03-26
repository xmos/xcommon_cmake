This test checks that pre-compilation analysis (PCA) is performed by compiling a source
file with a main() function that makes a call to function add_1() which can be
specialised with knowledge of how it is called.

The test directory name contains space characters to ensure that the commands that are
constructed for PCA contain correctly escaped strings.
