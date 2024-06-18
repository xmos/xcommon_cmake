#include "static0.h"

#ifdef LIB_STATIC0_OPTION
#error "LIB_STATIC0_OPTION not expected to be defined here"
#endif

#ifndef LIB_STATIC0_OPTION_archive
#error "LIB_STATIC0_OPTION_archive expected to be defined here"
#endif

void static0() {}
