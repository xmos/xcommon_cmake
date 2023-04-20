#include <print.h>

//#ifdef FLAG1
//#error
//#endif

#ifdef FLAG2
#error
#endif

#ifndef FLAG3
#error
#endif

#ifdef FLAG4
#error
#endif

extern "C" void flag3();

void flag3() 
{
    printintln(FLAG3);
}
