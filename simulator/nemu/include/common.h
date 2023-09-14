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

#ifndef __COMMON_H__
#define __COMMON_H__

#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>
#include <string.h>

#include <generated/autoconf.h>
#include <macro.h>
#include <assert.h>
#include <stdlib.h>


typedef uint32_t word_t;
typedef int32_t  sword_t;
typedef unsigned long long duword_t;
typedef long long dsword_t;

#define FMT_WORD "0x%08x"

typedef word_t vaddr_t;
typedef uint32_t paddr_t;
#define FMT_PADDR "0x%08x"
typedef uint16_t ioaddr_t;

#include <debug.h>

#endif
