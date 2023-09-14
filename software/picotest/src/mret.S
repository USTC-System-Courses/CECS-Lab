#include "riscv_test.h"
#include "test_macros.h"

.text
.global mret

trap_vec:
    # check mstatus should be 0x3E
    csrr t0, mstatus
    li t1, 0x3E
    bne t0, t1, fail
    # check mcause shoule be 0xb
    csrr t0, mcause
    li t1, 0xb
    bne t0, t1, fail
    # check mepc should be ecall_pc
    csrr t0, mepc
    la t1, ecall_pc
    bne t0, t1, fail
    # add mepc by 4
    addi t0, t0, 4
    csrw mepc, t0
    mret
mret:
    csrw mstatus, 0x7
    la t0, trap_vec
    csrw mtvec, t0
.global ecall_pc
ecall_pc:
    ecall
    #check mstatus should be 0x207
    csrr t0, mstatus
    li t1, 0x207
    bne t0, t1, fail
    TEST_PASSFAIL
