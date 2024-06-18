#include "static0.h"
#include "static0_aux.h"
#include "static1.h"
#include "static1_aux.h"
#include "print.h"
#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)
#ifndef MSG
#error MSG not defined
#endif

void static0_aux_cxx();
void static0_aux_S();

int main()
{
    printstrln(STRINGIFY(MSG));
    printstrln(STRINGIFY(CONFIG));
    static0();
    static0_aux_c();
    static0_aux_xc();
    static0_aux_cxx();
    static0_aux_S();
    static1();
    return 0;
}
