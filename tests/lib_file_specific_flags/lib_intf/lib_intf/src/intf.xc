#include "intf.h"

#ifdef LIB_INTF_OPTION
#error LIB_INTF_OPTION should not be defined in intf.xc
#endif

#ifndef APP_OPTION
#error APP_OPTION not defined
#endif

#ifndef INTF_FILE_OPTION
#error INTF_FILE_OPTION not defined in intf.xc
#endif

void intf() {}

