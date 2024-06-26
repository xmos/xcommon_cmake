#include "static1.h"
#include "print.h"
void static1_archive()
{
#ifdef __XS3A__
    printstrln("static1 archive xs3a");
#else
    printstrln("static1 archive xs2a");
#endif
}

