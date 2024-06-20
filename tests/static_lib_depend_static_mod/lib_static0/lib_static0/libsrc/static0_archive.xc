#include "static0.h"
#include "mod0.h"
#include "print.h"
void static0_archive()
{
#ifdef __XS3A__
    printstrln("static0 xs3a");
#else
    printstrln("static0 xs2a");
#endif
    mod0();
}

