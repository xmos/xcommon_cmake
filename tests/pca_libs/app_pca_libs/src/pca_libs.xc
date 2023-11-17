#include <xs1.h>
#include <print.h>
#include "mod0.h"
#include "mod1.h"

int add_1(int a)
{
    return a + 1;
} 

int main()
{
    int x, y, z;
    x = add_1(1);
    y = add_2(1);
    z = add_3(1);
   
    printintln(x);
    printintln(y);
    printintln(z);

    return 0;
}

