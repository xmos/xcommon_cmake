#include "static1_archive.h"
#include "static1.h"
#include <print.h>

#ifdef LIB_STATIC1_OPTION
#error "LIB_STATIC1_OPTION not expected to be defined here"
#endif

#ifndef LIB_STATIC1_OPTION_archive
#error "LIB_STATIC1_OPTION_archive expected to be defined here"
#endif

void static1_archive()
{
#if defined(__XS3A__)
    printstrln("static1 xs3a");
#endif

#if defined(__XS2A__)
    printstrln("static1 xs2a");
#endif
}
