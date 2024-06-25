#include "static0.h"
#include "static1.h"
#include "print.h"
#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)
#ifndef MSG
#error MSG not defined
#endif

void static0_cxx();
void static0_S();

int main()
{
    printstrln(STRINGIFY(MSG));
    printstrln(STRINGIFY(CONFIG));

    /* Call func from lib_static0 archive - prints "staticX archiveY xsZa") based on archive
     * config/arch */
    static0_archive();

    /* Call some functions from additional source files in lib_static0 */
    static0_c();
    static0_xc();
    static0_cxx();
    static0_S();

    /* Call func from lib_static1 archive - prints "static1 xsXa" based on arch */
    static1_archive();
    return 0;
}
