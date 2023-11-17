#include "mod0.h"

#ifndef LIB_MOD0_OPTION
#error LIB_MOD0_OPTION not defined
#endif

#ifdef LIB_MOD1_OPTION
#error LIB_MOD1_OPTION defined in lib_mod0
#endif

#ifndef APP_OPTION
#error APP_OPTION not defined
#endif

void mod0() {}

