/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#ifndef __ISA_RISCV_H__
#define __ISA_RISCV_H__

#include <common.h>
typedef struct {
  word_t mepc;
  word_t mstatus;
  word_t mcause;
  word_t mtvec;
} CSR;

typedef struct {
  word_t gpr[32];
  vaddr_t pc;
  CSR csr;
} riscv32_CPU_state;

// decode
typedef struct {
  union {
    uint32_t val;
  } inst;
} riscv32_ISADecodeInfo;

#endif
