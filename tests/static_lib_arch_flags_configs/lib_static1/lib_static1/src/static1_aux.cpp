#include "static1_aux.h"

#ifndef LIB_STATIC1_OPTION
#error "This should be defined"
#endif

extern "C" {
    void static1_aux_cxx() {}
}
