#define TEST_CSR_OP(testnum, inst, result, val_init, val_op, srcr, csr, destr) \
    test_ ## testnum: \
    li srcr, val_init; \
    csrw csr, srcr; \
    li srcr, val_op; \
    inst x0, csr, srcr; \
    csrr destr, csr; \
    li x31, result; \
    bne destr, x31, fail;

#define TEST_CSR_SRC_EQ_DEST(testnum, inst, result, val_init, val_op, gr, csr) \
    TEST_CSR_OP(testnum, inst, result, val_init, val_op, gr, csr, gr)

#define TEST_CSR_BYPASS(testnum, inst, result, val_init, val_op, srcr, csr, destr, nop_cnt) \
    test_ ## testnum: \
    li srcr, val_init; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    csrw csr, srcr; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    li srcr, val_op; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    inst x0, csr, srcr; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    csrr destr, csr; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    li x31, result; \
    bne destr, x31, fail;

#define TEST_CSR_ZERO_SRC(testnum, inst, result, val_init, val_op, srcr, csr, destr) \
    test_ ## testnum: \
    li srcr, val_init; \
    csrw csr, srcr; \
    li srcr, val_op; \
    inst x0, csr, x0; \
    csrr destr, csr; \
    li x31, result; \
    bne destr, x31, fail;

#define TEST_CSR_ZERO_DEST(testnum, inst, val_init, val_op, srcr, csr) \
    test_ ## testnum: \
    li srcr, val_init; \
    csrw csr, srcr; \
    li srcr, val_op; \
    inst x0, csr, srcr; \
    li x31, 0x0; \
    bne x0, x31, fail;

#define TEST_CSRI_OP(testnum, inst, result, val_init, val_op, csr, destr) \
    test_ ## testnum: \
    li x31, val_init; \
    csrw csr, x31; \
    inst x0, csr, val_op; \
    csrr destr, csr; \
    li x31, result; \
    bne destr, x31, fail;

#define TEST_CSRI_BYPASS(testnum, inst, result, val_init, val_op, csr, destr, nop_cnt) \
    test_ ## testnum: \
    li x31, val_init; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    csrw csr, x31; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    inst x0, csr, val_op; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    csrr destr, csr; \
    TEST_INSERT_NOPS_ ## nop_cnt; \
    li x31, result; \
    bne destr, x31, fail;

#define TEST_CSRI_ZERO_DEST(testnum, inst, val_init, val_op, csr) \
    test_ ## testnum: \
    li x31, val_init; \
    csrw csr, x31; \
    inst x0, csr, val_op; \
    li x31, 0x0; \
    bne x0, x31, fail;
