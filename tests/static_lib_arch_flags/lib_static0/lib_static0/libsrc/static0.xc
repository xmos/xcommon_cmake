#include "static0_archive.h"
#include <print.h>

#ifdef LIB_STATIC0_OPTION
#error "LIB_STATIC0_OPTION not expected to be defined here"
#endif

#endif

void static0()
{
#if defined(__XS3A__) && defined(LIB_STATIC0_OPTION_archive0)
    printstr("archive0 xs3a");
#endif

#if defined(__XS2A__) && defined(LIB_STATIC0_OPTION_archive0)
    printstr("archive0 xs2a");
#endif

#if defined(__XS3A__) && defined(LIB_STATIC0_OPTION_archive1)
    printstr("archive1 xs3a");
#endif

#if defined(__XS2A__) && defined(LIB_STATIC0_OPTION_archive1)
    printstr("archive1 xs3a");
#endif
}
