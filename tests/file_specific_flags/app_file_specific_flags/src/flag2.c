#include <print.h>

#ifdef FLAG1
#error
#endif

#ifndef FLAG2
#error
#endif

#ifdef FLAG3
#error
#endif

#ifdef FLAG4
#error
#endif

void flag2() 
{
    printintln(FLAG2);
}
