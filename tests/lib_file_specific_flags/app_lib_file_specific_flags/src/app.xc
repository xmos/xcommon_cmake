#include "mod0.h"

#ifndef APP_OPTION
#error APP_OPTION not defined
#endif

#ifdef LIB_MOD0_OPTION
#error LIB_MOD0_OPTION defined
#endif

int main()
{
    mod0();
    mod0A();
    return 0;
}
