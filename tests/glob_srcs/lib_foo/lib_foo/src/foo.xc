#include "foo.h"

void foo0_xc();
void foo1_xc();
void foo0_c();
void foo1_c();
void foo0_cxx();
void foo1_cxx();
void foo0_S();
void foo1_S();

void foo() {
    foo0_xc();
    foo1_xc();
    foo0_c();
    foo1_c();
    foo0_cxx();
    foo1_cxx();
    foo0_S();
    foo1_S();
}
