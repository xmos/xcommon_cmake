#include <print.h>

#ifndef FLAG1
#error
#endif

#ifdef FLAG2
#error
#endif

#ifdef FLAG3
#error
#endif

#ifdef FLAG4
#error
#endif

#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)
#ifndef MSG
#error MSG not defined
#endif

void flag2();
void flag3();

int main() 
{
    printstrln(STRINGIFY(MSG));
    printintln(FLAG1);
    flag2();
    flag3();
    return 0;
}
