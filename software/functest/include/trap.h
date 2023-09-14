#ifndef __TRAP_H__
#define __TRAP_H__

#include <base.h>
#include <tool.h>

__attribute__((noinline))
void check(int cond) {
  if (!cond) halt(1);
}

#define LENGTH(arr)         (sizeof(arr) / sizeof((arr)[0]))
#endif