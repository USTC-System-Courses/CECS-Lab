#include "riscv_test.h"
#include "test_macros.h"
#include "test_macros_csr.h"

.text
.global csrrs
csrrs:
TEST_CSR_OP(0, csrrs, 0x8027df7b, 0x7db43, 0x8026c77b, x15, mstatus, x26)
TEST_CSR_OP(1, csrrs, 0x13df6ef4, 0x3c662d4, 0x11dd4ce4, x12, mtvec, x19)
TEST_CSR_OP(2, csrrs, 0xfffeff7f, 0x37e27d6a, 0xfb9ed255, x2, mepc, x13)
TEST_CSR_OP(3, csrrs, 0xff5aefcd, 0xbd520a0d, 0x7b4aefc9, x5, mepc, x21)
TEST_CSR_OP(4, csrrs, 0xb, 0x9, 0xa, x25, mcause, x7)
TEST_CSR_OP(5, csrrs, 0x3ee7fd, 0xa27a5, 0x3cc5f9, x7, mstatus, x30)
TEST_CSR_OP(6, csrrs, 0xde6f7f3b, 0x9e62113a, 0xd24d6f3b, x10, mepc, x10)
TEST_CSR_OP(7, csrrs, 0xee2ffdfc, 0x6a2fe820, 0xac2615fc, x20, mtvec, x11)
TEST_CSR_OP(8, csrrs, 0x8000000a, 0x8000000a, 0x8000000a, x2, mcause, x9)
TEST_CSR_OP(9, csrrs, 0x803f37df, 0x8008251b, 0x3716d7, x2, mstatus, x10)
TEST_CSR_OP(10, csrrs, 0x8037ffe9, 0x8037b8e9, 0x3657e8, x28, mstatus, x4)
TEST_CSR_OP(11, csrrs, 0xafecde70, 0x2748d250, 0xafac0c20, x6, mtvec, x15)
TEST_CSR_OP(12, csrrs, 0xbff7bfac, 0xbff2bfa8, 0x3c871884, x28, mtvec, x16)
TEST_CSR_OP(13, csrrs, 0x3e5fba, 0x18578a, 0x3e1c30, x3, mstatus, x6)
TEST_CSR_OP(14, csrrs, 0xf756dff4, 0xe216dfc0, 0x77521d74, x3, mtvec, x9)
TEST_CSR_OP(15, csrrs, 0xfffdf73d, 0xffe5073d, 0xc61cf625, x25, mepc, x19)
TEST_CSR_OP(16, csrrs, 0x19f9ecfe, 0x19e024ee, 0x1159e83e, x29, mepc, x15)
TEST_CSR_OP(17, csrrs, 0x7769bef6, 0x76699c22, 0x5100aaf4, x30, mepc, x25)
TEST_CSR_OP(18, csrrs, 0x802d9bfe, 0x2d82d0, 0x800d9b3e, x29, mstatus, x15)
TEST_CSR_OP(19, csrrs, 0x80374e3f, 0x35463e, 0x80070e05, x18, mstatus, x30)

TEST_CSR_SRC_EQ_DEST(20, csrrs, 0x7c5dfebb, 0x34555ea8, 0x4c0ce693, x11, mepc)
TEST_CSR_SRC_EQ_DEST(21, csrrs, 0x7ffcff7c, 0x6f7c3c38, 0x72b0db5c, x8, mtvec)
TEST_CSR_SRC_EQ_DEST(22, csrrs, 0xdfdcccf6, 0x8fdcc884, 0x50d0cc72, x14, mepc)
TEST_CSR_SRC_EQ_DEST(23, csrrs, 0x8000000f, 0x8000000e, 0x80000009, x16, mcause)
TEST_CSR_SRC_EQ_DEST(24, csrrs, 0xf, 0x3, 0xc, x15, mcause)

TEST_CSR_BYPASS(25, csrrs, 0x803fea7e, 0x8034ea64, 0x801f223a, x15, mstatus, x20, 0)
TEST_CSR_BYPASS(26, csrrs, 0x3ffdd4, 0xae9d4, 0x3f1c00, x15, mstatus, x6, 1)
TEST_CSR_BYPASS(27, csrrs, 0xedefce10, 0xedef4810, 0xa025ce00, x25, mtvec, x8, 2)
TEST_CSR_BYPASS(28, csrrs, 0x803ffd5f, 0x8003bd53, 0x803e481f, x3, mstatus, x11, 3)
TEST_CSR_BYPASS(29, csrrs, 0x372eb9, 0x2728a9, 0x142e18, x28, mstatus, x11, 4)
TEST_CSR_BYPASS(30, csrrs, 0x7fefc7bd, 0x3f84c73d, 0x5c6b0691, x7, mepc, x15, 5)

TEST_CSR_ZERO_SRC(31, csrrs, 0xb45fb617, 0xb45fb617, 0x9c9258f3, x19, mepc, x28)
TEST_CSR_ZERO_SRC(32, csrrs, 0x80300b55, 0x80300b55, 0x802c2304, x17, mstatus, x20)
TEST_CSR_ZERO_SRC(33, csrrs, 0xc4087e80, 0xc4087e80, 0x71b1ec7c, x30, mtvec, x17)
TEST_CSR_ZERO_SRC(34, csrrs, 0x8000000a, 0x8000000a, 0x4, x2, mcause, x8)

TEST_CSR_ZERO_DEST(35, csrrs, 0x802c6ff0, 0x8016d6d1, x5, mstatus)
TEST_CSR_ZERO_DEST(36, csrrs, 0xc78577e0, 0xeeb29298, x21, mtvec)
TEST_CSR_ZERO_DEST(37, csrrs, 0xd, 0x80000007, x18, mcause)
TEST_CSR_ZERO_DEST(38, csrrs, 0x3fa037, 0x800cb762, x28, mstatus)
TEST_CSR_ZERO_DEST(39, csrrs, 0x3634f2, 0x8024d312, x19, mstatus)

TEST_PASSFAIL
