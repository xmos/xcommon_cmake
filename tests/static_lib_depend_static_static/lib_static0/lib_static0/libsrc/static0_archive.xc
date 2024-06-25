#include "static0.h"
#include "static1.h"
#include "print.h"
void static0_archive()
{
#ifdef __XS3A__
    printstrln("static0 archive xs3a");
#else
    printstrln("static0 archive xs2a");
#endif
    static1();
    static1_archive();
}

