#include "mod0.h"

#ifdef LIB_MOD0_OPTION
#error LIB_MOD0_OPTION should not be defined in mod0.xc
#endif

#ifndef APP_OPTION
#error APP_OPTION not defined
#endif

#ifndef MOD0_FILE_OPTION
#error MOD0_FILE_OPTION not defined in mod0.xc
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

void mod0() {}
