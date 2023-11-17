.globl mod0_asm.nstackwords
.linkset mod0_asm.nstackwords, 0
.globl mod0_asm
.text
.cc_top mod0_asm.func, mod0_asm
.align 16
mod0_asm:
    ldc     r0, 0
    retsp   0

.cc_bottom mod0_asm.func
