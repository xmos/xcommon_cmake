.globl intf_asm.nstackwords
.linkset intf_asm.nstackwords, 0
.globl intf_asm
.text
.cc_top intf_asm.func, intf_asm
.align 16
intf_asm:
    ldc     r0, 0
    retsp   0

.cc_bottom intf_asm.func
