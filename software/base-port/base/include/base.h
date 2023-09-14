#ifndef BASE_H__
#define BASE_H__

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <arch.h>
#include <dev.h>


typedef struct {
  void *start, *end;
} Area;

typedef struct {
  int pgsize;
  Area area;
  void *ptr;
} AddrSpace;

typedef struct {
  enum {
    EVENT_NULL = 0,
    EVENT_YIELD, EVENT_SYSCALL, EVENT_PAGEFAULT, 
    EVENT_IRQ_TIMER, EVENT_IRQ_IODEV,
    EVENT_ERROR,
  } event;
  uintptr_t cause, ref;
  const char *msg;
} Event;

extern   Area        heap;
void halt(int code);
void putch(char ch);
bool ioe_init();
void ioe_read(int reg, void *buf);
void ioe_write(int reg, void *buf);
void yield();
bool cte_init(Context *(*handler)(Event, Context *));

#include <base-macro.h>
#endif
