
#ifndef LIB_STATIC1_OPTION
#error "This should be defined"
#endif

.globl static1_S
.type static1_S,@function
.cc_top static1_S.function
static1_S:
  entsp   0
  retsp   0
.cc_bottom static1_S.function
