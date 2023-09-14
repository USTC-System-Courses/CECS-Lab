#include "riscv_test.h"
#include "test_macros.h"
#include "test_macros_csr.h"

.text
.global csrrw
csrrw:
TEST_CSR_OP(0, csrrw, 0x253033, 0x3b9a59, 0x253033, x14, mstatus, x18)
TEST_CSR_OP(1, csrrw, 0x80000008, 0x8000000e, 0x80000008, x3, mcause, x14)
TEST_CSR_OP(2, csrrw, 0x2, 0x4, 0x2, x5, mcause, x15)
TEST_CSR_OP(3, csrrw, 0x8000000f, 0x9, 0x8000000f, x12, mcause, x28)
TEST_CSR_OP(4, csrrw, 0x800124e6, 0x8023f433, 0x800124e6, x16, mstatus, x9)
TEST_CSR_OP(5, csrrw, 0x916c6a0d, 0x590b72e0, 0x916c6a0d, x8, mepc, x20)
TEST_CSR_OP(6, csrrw, 0x34113ae8, 0x8f899c8, 0x34113ae8, x13, mtvec, x16)
TEST_CSR_OP(7, csrrw, 0xbaee998, 0xc26bdae4, 0xbaee998, x29, mtvec, x20)
TEST_CSR_OP(8, csrrw, 0x393fe6e4, 0xe5c75420, 0x393fe6e4, x21, mtvec, x10)
TEST_CSR_OP(9, csrrw, 0x8035ad99, 0x308763, 0x8035ad99, x23, mstatus, x8)
TEST_CSR_OP(10, csrrw, 0xcb325734, 0x916feb98, 0xcb325734, x19, mtvec, x25)
TEST_CSR_OP(11, csrrw, 0x8010b03e, 0x801b500b, 0x8010b03e, x9, mstatus, x20)
TEST_CSR_OP(12, csrrw, 0x800cb597, 0x3a0801, 0x800cb597, x25, mstatus, x21)
TEST_CSR_OP(13, csrrw, 0x2, 0x8000000f, 0x2, x23, mcause, x5)
TEST_CSR_OP(14, csrrw, 0x30ffb7a4, 0xcf7ee83c, 0x30ffb7a4, x15, mtvec, x22)
TEST_CSR_OP(15, csrrw, 0x2d988844, 0xe814bb5c, 0x2d988844, x18, mtvec, x30)
TEST_CSR_OP(16, csrrw, 0xd63ca920, 0x1be28dd8, 0xd63ca920, x22, mtvec, x3)
TEST_CSR_OP(17, csrrw, 0x801273e2, 0x23dba, 0x801273e2, x27, mstatus, x20)
TEST_CSR_OP(18, csrrw, 0x106f234a, 0x2e9b4b20, 0x106f234a, x15, mepc, x28)
TEST_CSR_OP(19, csrrw, 0xc0b67b20, 0x965d4d94, 0xc0b67b20, x8, mtvec, x17)

TEST_CSR_SRC_EQ_DEST(20, csrrw, 0xd, 0x8, 0xd, x19, mcause)
TEST_CSR_SRC_EQ_DEST(21, csrrw, 0x32987104, 0xb6f1b9a0, 0x32987104, x29, mtvec)
TEST_CSR_SRC_EQ_DEST(22, csrrw, 0x80000007, 0x80000005, 0x80000007, x15, mcause)
TEST_CSR_SRC_EQ_DEST(23, csrrw, 0x8038250f, 0x80376b78, 0x8038250f, x21, mstatus)
TEST_CSR_SRC_EQ_DEST(24, csrrw, 0x8019fe66, 0x8004fb0b, 0x8019fe66, x17, mstatus)

TEST_CSR_BYPASS(25, csrrw, 0x3, 0x4, 0x3, x8, mcause, x26, 0)
TEST_CSR_BYPASS(26, csrrw, 0x5b2ab5b8, 0x89428c18, 0x5b2ab5b8, x12, mtvec, x22, 1)
TEST_CSR_BYPASS(27, csrrw, 0x6b38bd18, 0xa497cbba, 0x6b38bd18, x13, mepc, x21, 2)
TEST_CSR_BYPASS(28, csrrw, 0x8000000b, 0x8, 0x8000000b, x14, mcause, x29, 3)
TEST_CSR_BYPASS(29, csrrw, 0xbd8d2ba9, 0x95607e60, 0xbd8d2ba9, x25, mepc, x17, 4)
TEST_CSR_BYPASS(30, csrrw, 0xda65aaf0, 0x1b63aba8, 0xda65aaf0, x23, mtvec, x29, 5)

TEST_CSR_ZERO_SRC(31, csrrw, 0x0, 0x9f944fe4, 0x33c17e74, x22, mtvec, x23)
TEST_CSR_ZERO_SRC(32, csrrw, 0x0, 0x31d741bc, 0xfcc844c0, x9, mtvec, x19)
TEST_CSR_ZERO_SRC(33, csrrw, 0x0, 0x394c4e, 0x220c33, x4, mstatus, x20)
TEST_CSR_ZERO_SRC(34, csrrw, 0x0, 0xe8513743, 0xeb9d38ad, x21, mepc, x27)

TEST_CSR_ZERO_DEST(35, csrrw, 0x379ccfcb, 0xc92a6da0, x10, mepc)
TEST_CSR_ZERO_DEST(36, csrrw, 0xe, 0x7, x19, mcause)
TEST_CSR_ZERO_DEST(37, csrrw, 0x801b87a2, 0x311d62, x19, mstatus)
TEST_CSR_ZERO_DEST(38, csrrw, 0x2bc7db00, 0x156b5908, x2, mtvec)
TEST_CSR_ZERO_DEST(39, csrrw, 0x80000009, 0x80000009, x17, mcause)

TEST_PASSFAIL
