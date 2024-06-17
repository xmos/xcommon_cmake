#include "static0.h"

#ifdef LIB_STATIC0_OPTION
#error "LIB_STATIC0_OPTION not expected to be defined here"
#endif

#ifdef __XS3A__
#ifndef LIB_STATIC0_OPTION_archive_xs3
#error "Expect LIB_STATIC0_OPTION_archive_xs3 to be defined here"
#endif

#ifdef LIB_STATIC0_OPTION_archive_xs2
#error "Do not expect LIB_STATIC0_OPTION_archive_xs2 to be defined here"
#endif
#endif

void static0() {}
