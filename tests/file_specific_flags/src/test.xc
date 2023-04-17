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

void flag2();
void flag3();

int main() 
{
    printintln(FLAG1);
    flag2();
    flag3();
    return 0;
}
