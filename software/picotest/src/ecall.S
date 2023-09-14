#include "riscv_test.h"
#include "test_macros.h"

.text
.global ecall

trap_vec:
    # check mstatus should be 0x3E
    csrr t0, mstatus
    li t1, 0x3E
    bne t0, t1, fail
    # check mcause shoule be 0xb
    csrr t0, mcause
    li t1, 0xb
    bne t0, t1, fail
    # check mepc should be mret_pc
    csrr t0, mepc
    la t1, mret_pc
    bne t0, t1, fail
    # pass
    TEST_PASSFAIL
ecall:
    csrw mstatus, 0x7
    la t0, trap_vec
    csrw mtvec, t0
.global mret_pc
mret_pc:
    ecall
    j fail