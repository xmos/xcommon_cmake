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

#if LIB_MOD1_VERSION_MAJOR != 4
#error LIB_MOD1_VERSION_MAJOR incorrect
#endif

#if LIB_MOD1_VERSION_MINOR != 5
#error LIB_MOD1_VERSION_MINOR incorrect
#endif

#if LIB_MOD1_VERSION_PATCH != 6
#error LIB_MOD1_VERSION_PATCH incorrect
#endif

#ifdef LIB_MOD0_VERSION_MAJOR
#error LIB_MOD0_VERSION_MAJOR defined in lib_mod1
#endif

void mod1() {}
