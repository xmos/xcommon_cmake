#include "mod1.h"

#ifdef LIB_MOD0_OPTION
#error LIB_MOD0_OPTION defined in lib_mod1
#endif

#ifndef LIB_MOD1_OPTION
#error LIB_MOD1_OPTION not defined
#endif

#ifndef APP_OPTION
#error APP_OPTION not defined
#endif

void mod1() {}

