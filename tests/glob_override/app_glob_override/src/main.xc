#include "foo.h"
#include "bar.h"

void src0_xc();
void src1_cxx();
void src0_S();

int main() {
    src0_xc();
    src1_cxx();
    src0_S();
    foo();
    bar();
    return 0;
}
