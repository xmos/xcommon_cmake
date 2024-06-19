#include "static0.h"
#include <print.h>
void static0_archive() {
#ifdef __XS3A__
    printstrln("arch xs3a");
#else
    printstrln("arch xs2a");
#endif
}

