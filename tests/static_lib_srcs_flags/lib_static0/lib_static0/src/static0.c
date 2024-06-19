#include "static0.h"

#ifndef __static0_conf_h_exists__
#error "This should be defined"
#endif

#ifndef LIB_STATIC0_OPTION
#error "LIB_STATIC0_OPTION expected to be defined here"
#endif

#include "print.h"
#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)
#ifndef MSG
#error MSG not defined
#endif

void static0_c()
{
    printstrln(STRINGIFY(MSG));
}
