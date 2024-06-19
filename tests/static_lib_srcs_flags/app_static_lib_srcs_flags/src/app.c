#include "static0.h"
//#include "static0_static.h" // shouldn't be able to see this, used for building .a only

void static0_cxx();
void static0_S();

int main()
{
    // Func from .a
    static0_archive(); // prints MSG_ARCHICE

    // Funcs from additional source files
    static0_c(); // prints MSG
    static0_xc(); // calls static0_archive (prints MSG_ARCHIVE)
    static0_cxx();
    static0_S();
    return 0;
}
