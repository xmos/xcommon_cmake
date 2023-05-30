#include "intf.h"
#include "print.h"
#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)

#ifndef MSG
#error MSG not defined
#endif

void intf() 
{
    printstrln(STRINGIFY(MSG));
}
