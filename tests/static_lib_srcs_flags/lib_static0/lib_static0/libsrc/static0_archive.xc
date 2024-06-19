#include "static0_archive.h"

#ifdef LIB_STATIC0_OPTION
#error "LIB_STATIC0_OPTION not expected to be defined here"
#endif

#ifndef LIB_STATIC0_OPTION_archive
#error "LIB_STATIC0_OPTION_archive expected to be defined here"
#endif

#include "print.h"
#define STRINGIFY0(x) #x
#define STRINGIFY(x) STRINGIFY0(x)
#ifndef MSG_ARCHIVE
#error MSG_ARCHIVE not defined
#endif

void static0_archive()
{
    printstrln(STRINGIFY(MSG_ARCHIVE));
}
