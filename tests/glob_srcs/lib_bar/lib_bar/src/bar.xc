#include "bar.h"

void bar0_xc();
void bar1_xc();
void bar0_c();
void bar1_c();
void bar0_cxx();
void bar1_cxx();
void bar0_S();
void bar1_S();

void bar() {
    bar0_xc();
    bar1_xc();
    bar0_c();
    bar1_c();
    bar0_cxx();
    bar1_cxx();
    bar0_S();
    bar1_S();
}
