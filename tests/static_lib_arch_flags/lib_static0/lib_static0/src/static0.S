
#ifndef LIB_STATIC0_OPTION
#error "This should be defined"
#endif

.globl static0_aux_S
.type static0_aux_S,@function
.cc_top static0_aux_S.function
static0_aux_S:
  entsp   0
  retsp   0
.cc_bottom static0_aux_S.function
