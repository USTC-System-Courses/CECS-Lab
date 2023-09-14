import random

class TestGen:
    def __init__(self, __inst: str):
        self.inst = __inst

    def legal_op_gen(self, csr):
        if self.inst[-1] == 'i':
            if csr == 'mstatus':
                return (random.randint(0, 0x1F) & 0x803FFFFF, random.randint(0, 0x1F) & 0x803FFFFF)
            elif csr == 'mtvec':
                return (random.randint(0, 0x1F) & 0xFFFFFFFC, random.randint(0, 0x1F) & 0xFFFFFFFC)
            elif csr == 'mcause':
                return (random.randint(0, 0x1F) & 0x8000000F, random.randint(0, 0x1F) & 0x8000000F)
            else:
                return (random.randint(0, 0x1F), random.randint(0, 0x1F))
        else:
            if csr == 'mstatus':
                return (random.randint(0, 0xFFFFFFFF) & 0x803FFFFF, random.randint(0, 0xFFFFFFFF) & 0x803FFFFF)
            elif csr == 'mtvec':
                return (random.randint(0, 0xFFFFFFFF) & 0xFFFFFFFC, random.randint(0, 0xFFFFFFFF) & 0xFFFFFFFC)
            elif csr == 'mcause':
                return (random.randint(0, 0xFFFFFFFF) & 0x8000000F, random.randint(0, 0xFFFFFFFF) & 0x8000000F)
            else:
                return (random.randint(0, 0xFFFFFFFF), random.randint(0, 0xFFFFFFFF))

    def predict(self, val_init, val_op):
        if self.inst == 'csrrw' or self.inst == 'csrrwi':
            return val_op
        if self.inst == 'csrrs' or self.inst == 'csrrsi':
            return val_init | val_op
        if self.inst == 'csrrc' or self.inst == 'csrrci':
            return val_init & (~val_op)

    def test_gen(self):
        with open(self.inst + '.S', 'w') as ofile:
            ofile.write('#include "riscv_test.h"\n')
            ofile.write('#include "test_macros.h"\n')
            ofile.write('#include "test_macros_csr.h"\n')
            ofile.write('\n')
            ofile.write('.text\n')
            ofile.write('.global {}\n'.format(self.inst))
            ofile.write('{}:\n'.format(self.inst))

            if self.inst == 'csrrw' or self.inst == 'csrrs' or self.inst == 'csrrc':
                for test_num in range(0, 20):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    result = self.predict(val_init, val_op)
                    srcr = random.randint(2, 30)
                    destr = random.randint(2, 30)
                    ofile.write('TEST_CSR_OP({:d}, {}, {:#x}, {:#x}, {:#x}, x{:d}, {}, x{:d})\n'.format(test_num, self.inst, result, val_init, val_op, srcr, csr, destr))

                ofile.write('\n')
                for test_num in range(20, 25):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    result = self.predict(val_init, val_op)
                    gr = random.randint(2, 30)
                    ofile.write('TEST_CSR_SRC_EQ_DEST({:d}, {}, {:#x}, {:#x}, {:#x}, x{:d}, {})\n'.format(test_num, self.inst, result, val_init, val_op, gr, csr))

                ofile.write('\n')
                for test_num in range(25, 31):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    result = self.predict(val_init, val_op)
                    srcr = random.randint(2, 30)
                    destr = random.randint(2, 30)
                    ofile.write('TEST_CSR_BYPASS({:d}, {}, {:#x}, {:#x}, {:#x}, x{:d}, {}, x{:d}, {:d})\n'.format(test_num, self.inst, result, val_init, val_op, srcr, csr, destr, test_num - 25))

                ofile.write('\n')
                for test_num in range(31, 35):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    result = self.predict(val_init, 0)
                    srcr = random.randint(2, 30)
                    destr = random.randint(2, 30)
                    ofile.write('TEST_CSR_ZERO_SRC({:d}, {}, {:#x}, {:#x}, {:#x}, x{:d}, {}, x{:d})\n'.format(test_num, self.inst, result, val_init, val_op, srcr, csr, destr))

                ofile.write('\n')
                for test_num in range(35, 40):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    srcr = random.randint(2, 30)
                    ofile.write('TEST_CSR_ZERO_DEST({:d}, {}, {:#x}, {:#x}, x{:d}, {})\n'.format(test_num, self.inst, val_init, val_op, srcr, csr))

            elif self.inst == 'csrrwi' or self.inst == 'csrrsi' or self.inst == 'csrrci':
                for test_num in range(0, 30):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    result = self.predict(val_init, val_op)
                    srcr = random.randint(2, 30)
                    destr = random.randint(2, 30)
                    ofile.write('TEST_CSRI_OP({:d}, {}, {:#x}, {:#x}, {:#x}, {}, x{:d})\n'.format(test_num, self.inst, result, val_init, val_op, csr, destr))

                ofile.write('\n')
                for test_num in range(30, 36):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    result = self.predict(val_init, val_op)
                    srcr = random.randint(2, 30)
                    destr = random.randint(2, 30)
                    ofile.write('TEST_CSRI_BYPASS({:d}, {}, {:#x}, {:#x}, {:#x}, {}, x{:d}, {:d})\n'.format(test_num, self.inst, result, val_init, val_op, csr, destr, test_num - 30))

                ofile.write('\n')
                for test_num in range(36, 40):
                    csr = ['mstatus', 'mtvec', 'mepc', 'mcause'][random.randint(0, 3)]
                    val_init, val_op = self.legal_op_gen(csr)
                    srcr = random.randint(2, 30)
                    ofile.write('TEST_CSRI_ZERO_DEST({:d}, {}, {:#x}, {:#x}, {})\n'.format(test_num, self.inst, val_init, val_op, csr))
            ofile.write('\nTEST_PASSFAIL\n')

if __name__ == '__main__':
    TestGen('csrrw').test_gen()
    TestGen('csrrs').test_gen()
    TestGen('csrrc').test_gen()
    TestGen('csrrwi').test_gen()
    TestGen('csrrsi').test_gen()
    TestGen('csrrci').test_gen()

