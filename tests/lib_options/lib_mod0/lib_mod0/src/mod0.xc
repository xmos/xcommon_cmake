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

#if LIB_MOD0_VERSION_MAJOR != 1
#error LIB_MOD0_VERSION_MAJOR incorrect
#endif

#if LIB_MOD0_VERSION_MINOR != 2
#error LIB_MOD0_VERSION_MINOR incorrect
#endif

#if LIB_MOD0_VERSION_PATCH != 3
#error LIB_MOD0_VERSION_PATCH incorrect
#endif

#ifdef LIB_MOD1_VERSION_MAJOR
#error LIB_MOD1_VERSION_MAJOR defined in lib_mod0
#endif

void mod0() {}
