#include "static0.h"

#ifndef LIB_STATIC0_OPTION
#error "This should be defined"
#endif

extern "C" {
    void static0_cxx() {}
}
