#include "static1.h"
#include <print.h>

#ifdef LIB_STATIC1_OPTION
#error "LIB_STATIC1_OPTION not expected to be defined here"
#endif

#ifndef LIB_STATIC_OPTION_archive
#error "LIB_STATIC1_OPTION_archive expected to be defined here"
#endif

void static1()
{
#if defined(__XS3A__)
    printstr("static1 xs3a");
#endif

#if defined(__XS2A__)
    printstr("static1 xs2a");
#endif
}
