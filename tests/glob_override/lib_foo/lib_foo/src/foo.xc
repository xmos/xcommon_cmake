#include "foo.h"

void foo0_xc();
void foo1_c();
void foo1_cxx();
void foo0_S();

void foo() {
    foo0_xc();
    foo1_c();
    foo1_cxx();
    foo0_S();
}
