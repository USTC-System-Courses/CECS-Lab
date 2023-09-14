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

#ifndef __DIFFTEST_DEF_H__
#define __DIFFTEST_DEF_H__

#include <stdint.h>
#include <macro.h>
#include <generated/autoconf.h>

#define __EXPORT __attribute__((visibility("default")))
enum { DIFFTEST_TO_DUT, DIFFTEST_TO_REF };


#define RISCV_GPR_TYPE uint32_t
#define RISCV_GPR_NUM  32
#define DIFFTEST_REG_SIZE (sizeof(RISCV_GPR_TYPE) * (RISCV_GPR_NUM + 1 + 4)) // GPRs + pc + 4 * csr


#endif
