.text
# .global _start
# _start:
#     # set stack pointer
#     li sp, 0x80000100

#define TEST(n) \
	.global n; \
	jal n; \

.global main
main:
    TEST(add)
    TEST(addi)
    TEST(and)
    TEST(andi)
    TEST(auipc)
    TEST(beq)
    TEST(bge)
    TEST(bgeu)
    TEST(blt)
    TEST(bltu)
    TEST(bne)
    TEST(div)
    TEST(divu)
    TEST(j)
    TEST(jal)
    TEST(jalr)
    TEST(lb)
    TEST(lbu)
    TEST(lh)
    TEST(lhu)
    TEST(lui)
    TEST(lw)
    TEST(mul)
    TEST(mulh)
    TEST(mulhsu)
    TEST(mulhu)
    TEST(or)
    TEST(ori)
    TEST(rem)
    TEST(remu)
    TEST(sb)
    TEST(sh)
    TEST(simple)
    TEST(sll)
    TEST(slli)
    TEST(slt)
    TEST(slti)
    TEST(sra)
    TEST(srai)
    TEST(srl)
    TEST(srli)
    TEST(sub)
    TEST(sw)
    TEST(xor)
    TEST(xori)
    TEST(csrrw)
    TEST(csrrs)
    TEST(csrrc)
    TEST(csrrwi)
    TEST(csrrsi)
    TEST(csrrci)

.global end_loop
end_loop:
    ebreak # stop simulation