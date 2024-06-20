#include "static1.h"

#ifndef LIB_STATIC1_OPTION
#error "This should be defined"
#endif

extern "C" {
    void static1_cxx() {}
}
