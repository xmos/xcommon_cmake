#include "foo.h"

#ifdef __foo_conf_h_exists__
#error "This should not be defined"
#endif

void foo() {}
