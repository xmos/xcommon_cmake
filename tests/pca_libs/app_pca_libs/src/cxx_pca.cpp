extern "C" {
    void fn_cxx()
    {
        // C++ flags are not passed to PCA command, so use nullptr from C++11 to
        // force a failure if PCA is performed on this C++ source file
        auto var0 = nullptr;
        (void) var0;
    }
}
