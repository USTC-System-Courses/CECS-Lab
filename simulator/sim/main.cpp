#include <verilated_vcd_c.h>
#include "VCPU.h"
#include <bits/stdc++.h>

#include "include/debug.h"
#include "include/common.h"
#include "include/disasm.h"


// verilog instance
VCPU *dut = new VCPU;
// wave tracer
VerilatedVcdC *m_trace = new VerilatedVcdC;

size_t sim_time = 0;
// state of our simulated cpu
CPU_state sim_cpu;

uint32_t *cpu_gpr = NULL;
// the runing state of simulator
extern SimState sim_state;

int main(int argc, char** argv, char** env) {
    printf(ANSI_FG_GREEN "Load img: %s\n" ANSI_NONE, argv[1]);
    
    uint64_t size = load_img(argv[1]);
    init_difftest(argv[2], size, 1234);
#ifdef DEVICE
    if (argc == 5) init_device(argv[4]);
    else init_device(" ");
#endif
    // init asm code translator
    init_disasm("riscv32");

    init_sdb(argv[3]);
    // start wave trace
    Verilated::traceEverOn(true);
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");
    reset(1);
    
    // start running
    sdb_mainloop();
    // end

    printf(ANSI_FG_GREEN "Testcase end!\n" ANSI_NONE);
    
    // close wave trace
    m_trace->close();
    delete dut;
    return sim_state.state == SIM_ABORT;
}
