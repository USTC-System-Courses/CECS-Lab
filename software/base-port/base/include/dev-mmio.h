#ifndef __DEV_MMIO_H__
#define __DEV_MMIO_H__
#include <stdint.h>

#define MMIO_BASE 0xa0000000
#define SERIAL_PORT     (MMIO_BASE + 0x00003f8)
#define KBD_ADDR        (MMIO_BASE + 0x0000060)
#define RTC_ADDR        (MMIO_BASE + 0x0000040)
#define VGACTL_ADDR     (MMIO_BASE + 0x0000100)
#define FB_ADDR         (MMIO_BASE + 0x1000000)
// fast fb draw
#define FFB_ADDR        (MMIO_BASE + 0x2000000)
// disk ctl
#define DISK_CTL_ADDR   (MMIO_BASE + 0x0000300)

static inline uint8_t  inb(uintptr_t addr) { return *(volatile uint8_t  *)addr; }
static inline uint16_t inw(uintptr_t addr) { return *(volatile uint16_t *)addr; }
static inline uint32_t inl(uintptr_t addr) { return *(volatile uint32_t *)addr; }

static inline void outb(uintptr_t addr, uint8_t  data) { *(volatile uint8_t  *)addr = data; }
static inline void outw(uintptr_t addr, uint16_t data) { *(volatile uint16_t *)addr = data; }
static inline void outl(uintptr_t addr, uint32_t data) { *(volatile uint32_t *)addr = data; }

#endif