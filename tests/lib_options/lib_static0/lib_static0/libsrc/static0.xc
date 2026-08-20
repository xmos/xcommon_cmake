#include "static0.h"

#ifndef LIB_STATIC0_ARCHIVE_OPTION
#error LIB_STATIC0_ARCHIVE_OPTION not defined
#endif

#ifdef LIB_STATIC0_OPTION
#error LIB_STATIC0_OPTION should not be defined
#endif

#if LIB_STATIC0_VERSION_MAJOR != 7
#error LIB_STATIC0_VERSION_MAJOR incorrect
#endif

#if LIB_STATIC0_VERSION_MINOR != 8
#error LIB_STATIC0_VERSION_MINOR incorrect
#endif

#if LIB_STATIC0_VERSION_PATCH != 9
#error LIB_STATIC0_VERSION_PATCH incorrect
#endif

void static0_archive() {}
