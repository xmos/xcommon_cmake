#include "mod0.h"
#include "static0.h"
#include "print.h"

#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)

#ifndef MSG
#error MSG not defined
#endif

int main()
{
    printstrln(STRINGIFY(MSG));
    printstrln(STRINGIFY(CONFIG));
    mod0();
    mod0_asm();
    static0();
    return 0;
}
