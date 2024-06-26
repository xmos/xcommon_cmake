#include "static0.h"
#include <print.h>

#ifdef LIB_STATIC0_OPTION
#error "LIB_STATIC0_OPTION not expected to be defined here"
#endif

void static0_archive()
{
#if defined(__XS3A__) && defined(LIB_STATIC0_OPTION_archive0)
    printstrln("static0 archive0 xs3a");
#endif

#if defined(__XS2A__) && defined(LIB_STATIC0_OPTION_archive0)
    printstrln("static0 archive0 xs2a");
#endif

#if defined(__XS3A__) && defined(LIB_STATIC0_OPTION_archive1)
    printstrln("static0 archive1 xs3a");
#endif

#if defined(__XS2A__) && defined(LIB_STATIC0_OPTION_archive1)
    printstrln("static0 archive1 xs3a");
#endif
}
