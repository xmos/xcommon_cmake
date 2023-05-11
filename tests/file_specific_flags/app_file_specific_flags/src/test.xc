#include <print.h>

#ifdef FLAG0
#error FLAG0 defined
#endif

#ifndef FLAG1
#error FLAG1 not defined
#endif

#if(FLAG1 != 1)
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

void flag2();
void flag3();
void flag10();

int main() 
{
    printintln(FLAG1);
    flag2();
    flag3();
    return 0;
}
