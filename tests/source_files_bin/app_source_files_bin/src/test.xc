#include "print.h"
#ifndef CFG
#error CFG not defined
#endif

#if(CFG!=3)
void printmsg();
#else
void printmsg()
{
    printstrln("test.xc");
}
#endif

int main() 
{
    printmsg();
    return 0;
}
