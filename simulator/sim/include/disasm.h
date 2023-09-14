#include <iostream>
// #include "common.h"
using namespace std;
extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
extern "C" void init_disasm(const char *triple);