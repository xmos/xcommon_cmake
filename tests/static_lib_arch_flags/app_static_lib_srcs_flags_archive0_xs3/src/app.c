#include "static0.h"
//#include "static0_archive.h" shouldn't be able to see this

void static0_cxx();
void static0_S();

int main()
{
    static0_archive();
    static0_c();
    static0_xc();
    static0_cxx();
    static0_S();
    return 0;
}
