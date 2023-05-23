#include "intf.h"
#include "stat.h"

#ifndef APP_OPTION
#error APP_OPTION not defined
#endif

#ifdef LIB_INTF_OPTION
#error LIB_INTF_OPTION defined
#endif

int main() {
    intf();
    stat();
    return 0;
}
