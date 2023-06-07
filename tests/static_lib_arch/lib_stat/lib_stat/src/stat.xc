#include "stat.h"
#include <print.h>
void stat() {
#ifdef __XS3A__
    printstrln("arch xs3a");
#else
    printstrln("arch xs2a");
#endif
}

