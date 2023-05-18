#include "foo.h"
#include <print.h>

#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)

#ifndef MSG
#error MSG is not defined
#endif

void foo() {
    printstrln(STRINGIFY(MSG));
}
