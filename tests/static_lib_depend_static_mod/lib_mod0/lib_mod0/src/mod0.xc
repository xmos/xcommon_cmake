#include "mod0.h"
#include "print.h"
void mod0()
{
#ifdef __XS3A__
    printstrln("mod0 xs3a");
#else
    printstrln("mod0 xs2a");
#endif
}

