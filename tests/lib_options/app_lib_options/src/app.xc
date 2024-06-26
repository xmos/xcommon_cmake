#include "mod0.h"
#include "mod1.h"
#include "static0.h"

#ifndef APP_OPTION
#error APP_OPTION not defined
#endif

#ifdef LIB_MOD0_OPTION
#error LIB_MOD0_OPTION defined
#endif

#ifdef LIB_STATIC0_ARCHIVE_OPTION
#error LIB_STATIC0_ARCHIVE_OPTION defined
#endif

int main() {
    mod0();
    mod1();
    static0_archive();
    return 0;
}
