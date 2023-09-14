#ifndef ARCH_H__
#define ARCH_H__

#include <stdint.h>
typedef struct {
  uintptr_t gpr[32], mcause, mstatus ,mepc;
} Context ;

#define SYS_NUM gpr[17] // a7
#define SYS_ARG1 gpr[10]
#define SYS_ARG2 gpr[11]
#define SYS_ARG3 gpr[12]
#define SYS_RET gpr[10]

#define PAGE_SHIFT        12
#define PAGE_SIZE         (1ul << PAGE_SHIFT)

#endif