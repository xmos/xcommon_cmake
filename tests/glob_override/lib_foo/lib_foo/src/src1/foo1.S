.globl foo1_S
.type foo1_S,@function
.cc_top foo1_S.function
foo1_S:
  #error "File should not be compiled"
  entsp   0
  retsp   0
.cc_bottom foo1_S.function
