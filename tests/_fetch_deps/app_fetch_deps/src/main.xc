#include <print.h>
#include "dsp.h"
#include "test_staticlib.h"

int main() {
    dsp_complex_t a = {1, 2};
    dsp_complex_t b = {3, 4};
    dsp_complex_t sum = dsp_complex_add(a, b);
    printintln(sum.re);
    printintln(sum.im);

    test_staticlib();

    return 0;
}
