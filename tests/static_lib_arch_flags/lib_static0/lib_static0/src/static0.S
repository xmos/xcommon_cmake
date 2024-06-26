
#ifndef LIB_STATIC0_OPTION
#error "This should be defined"
#endif

.globl static0_S
.type static0_S,@function
.cc_top static0_S.function
static0_S:
  entsp   0
  retsp   0
.cc_bottom static0_S.function
