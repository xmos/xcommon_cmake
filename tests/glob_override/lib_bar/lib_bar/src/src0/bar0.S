.globl bar0_S
.type bar0_S,@function
.cc_top bar0_S.function
bar0_S:
  #error "File should not be compiled"
  entsp   0
  retsp   0
.cc_bottom bar0_S.function
