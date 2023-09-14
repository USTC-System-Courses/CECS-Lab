#include "riscv_test.h"
#include "test_macros.h"
#include "test_macros_csr.h"

.text
.global csrrc
csrrc:
TEST_CSR_OP(0, csrrc, 0xb8450060, 0xb9dd6870, 0x43b86a98, x17, mtvec, x28)
TEST_CSR_OP(1, csrrc, 0xeecc080, 0xffcd888, 0x21131e78, x3, mtvec, x15)
TEST_CSR_OP(2, csrrc, 0x4100800, 0xc10ae80, 0x6883a7a0, x2, mtvec, x20)
TEST_CSR_OP(3, csrrc, 0x80000085, 0x8018c9b5, 0x38ff38, x6, mstatus, x30)
TEST_CSR_OP(4, csrrc, 0x8, 0x80000009, 0x80000005, x19, mcause, x9)
TEST_CSR_OP(5, csrrc, 0x80000009, 0x80000009, 0x0, x2, mcause, x21)
TEST_CSR_OP(6, csrrc, 0x8, 0x8, 0x80000005, x29, mcause, x24)
TEST_CSR_OP(7, csrrc, 0x2204dc, 0x8033ccde, 0x8011cb02, x19, mstatus, x24)
TEST_CSR_OP(8, csrrc, 0x14508004, 0x5754b44c, 0xcb067df8, x15, mtvec, x6)
TEST_CSR_OP(9, csrrc, 0x4, 0x80000006, 0x8000000b, x26, mcause, x16)
TEST_CSR_OP(10, csrrc, 0x8820000, 0xb9ce0340, 0xb15de748, x26, mtvec, x20)
TEST_CSR_OP(11, csrrc, 0x0, 0x80000001, 0x8000000d, x23, mcause, x12)
TEST_CSR_OP(12, csrrc, 0x2da00050, 0x6fa32c70, 0x421b2ca8, x28, mtvec, x15)
TEST_CSR_OP(13, csrrc, 0x62640703, 0xfb7c0703, 0x999848a0, x16, mepc, x6)
TEST_CSR_OP(14, csrrc, 0x15221190, 0x3d6f17d0, 0x28dd6e6d, x8, mepc, x9)
TEST_CSR_OP(15, csrrc, 0x0, 0x80000007, 0x8000000f, x18, mcause, x4)
TEST_CSR_OP(16, csrrc, 0x1, 0x1, 0x8000000c, x30, mcause, x20)
TEST_CSR_OP(17, csrrc, 0x40080280, 0xf3cc6a94, 0xb7d7fc14, x10, mtvec, x8)
TEST_CSR_OP(18, csrrc, 0x82d8, 0x4c4d2d8, 0x37cf7420, x6, mtvec, x6)
TEST_CSR_OP(19, csrrc, 0x50821408, 0x71b2dc18, 0x2539cb94, x6, mtvec, x23)

TEST_CSR_SRC_EQ_DEST(20, csrrc, 0x2, 0x6, 0xc, x10, mcause)
TEST_CSR_SRC_EQ_DEST(21, csrrc, 0x1, 0x80000005, 0x80000004, x6, mcause)
TEST_CSR_SRC_EQ_DEST(22, csrrc, 0xa5874080, 0xe78f70d0, 0x5a38b25b, x2, mepc)
TEST_CSR_SRC_EQ_DEST(23, csrrc, 0x50086050, 0x5088e350, 0x86c49ba8, x17, mtvec)
TEST_CSR_SRC_EQ_DEST(24, csrrc, 0xc1102c84, 0xc1913c95, 0x4c59273, x27, mepc)

TEST_CSR_BYPASS(25, csrrc, 0x87083044, 0xaf1cb64c, 0x38f78628, x28, mtvec, x4, 0)
TEST_CSR_BYPASS(26, csrrc, 0x256200, 0x80356bba, 0x801289bb, x4, mstatus, x16, 1)
TEST_CSR_BYPASS(27, csrrc, 0x3040004, 0xb5f7006, 0x38db770b, x7, mepc, x11, 2)
TEST_CSR_BYPASS(28, csrrc, 0x3d888c00, 0x3f8cbd00, 0x24673ac, x17, mtvec, x12, 3)
TEST_CSR_BYPASS(29, csrrc, 0x4030b2a0, 0x687abaa0, 0x3f4e0c58, x24, mtvec, x12, 4)
TEST_CSR_BYPASS(30, csrrc, 0xc870808, 0x4f8fcd6e, 0xe338f576, x3, mepc, x16, 5)

TEST_CSR_ZERO_SRC(31, csrrc, 0xa02ccab6, 0xa02ccab6, 0xe6a45dda, x30, mepc, x19)
TEST_CSR_ZERO_SRC(32, csrrc, 0x3, 0x3, 0x80000004, x27, mcause, x5)
TEST_CSR_ZERO_SRC(33, csrrc, 0x80000003, 0x80000003, 0x2, x20, mcause, x11)
TEST_CSR_ZERO_SRC(34, csrrc, 0x9bb4c478, 0x9bb4c478, 0xb7471924, x16, mtvec, x10)

TEST_CSR_ZERO_DEST(35, csrrc, 0x2693e1bb, 0x1ef6a829, x25, mepc)
TEST_CSR_ZERO_DEST(36, csrrc, 0xb6572232, 0x41a8de4e, x15, mepc)
TEST_CSR_ZERO_DEST(37, csrrc, 0xc97366b8, 0xc2aeb64c, x27, mtvec)
TEST_CSR_ZERO_DEST(38, csrrc, 0x1f697a3c, 0x2a885530, x3, mtvec)
TEST_CSR_ZERO_DEST(39, csrrc, 0xb, 0x8000000d, x25, mcause)

TEST_PASSFAIL
