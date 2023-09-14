#ifndef DEV_H__
#define DEV_H__
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
// **MAY SUBJECT TO CHANGE IN THE FUTURE**

#define DEVREG(id, reg, perm, ...) \
  enum { DEV_##reg = (id) }; \
  typedef struct { __VA_ARGS__; } DEV_##reg##_T;

DEVREG( 1, UART_CONFIG,  RD, bool present);
DEVREG( 2, UART_TX,      WR, char data);
DEVREG( 3, UART_RX,      RD, char data);
DEVREG( 4, TIMER_CONFIG, RD, bool present, has_rtc);
DEVREG( 5, TIMER_RTC,    RD, int year, month, day, hour, minute, second);
DEVREG( 6, TIMER_UPTIME, RD, uint64_t us);
DEVREG( 7, INPUT_CONFIG, RD, bool present);
DEVREG( 8, INPUT_KEYBRD, RD, bool keydown; int keycode);
DEVREG( 9, GPU_CONFIG,   RD, bool present, has_accel; int width, height, vmemsz);
DEVREG(10, GPU_STATUS,   RD, bool ready);
DEVREG(11, GPU_FBDRAW,   WR, int x, y; void *pixels; int w, h; bool sync);
DEVREG(12, GPU_MEMCPY,   WR, uint32_t dest; void *src; int size);
DEVREG(13, GPU_RENDER,   WR, uint32_t root);

// Input

#define KEYS(_) \
  _(ESCAPE) _(F1) _(F2) _(F3) _(F4) _(F5) _(F6) _(F7) _(F8) _(F9) _(F10) _(F11) _(F12) \
  _(GRAVE) _(1) _(2) _(3) _(4) _(5) _(6) _(7) _(8) _(9) _(0) _(MINUS) _(EQUALS) _(BACKSPACE) \
  _(TAB) _(Q) _(W) _(E) _(R) _(T) _(Y) _(U) _(I) _(O) _(P) _(LEFTBRACKET) _(RIGHTBRACKET) _(BACKSLASH) \
  _(CAPSLOCK) _(A) _(S) _(D) _(F) _(G) _(H) _(J) _(K) _(L) _(SEMICOLON) _(APOSTROPHE) _(RETURN) \
  _(LSHIFT) _(Z) _(X) _(C) _(V) _(B) _(N) _(M) _(COMMA) _(PERIOD) _(SLASH) _(RSHIFT) \
  _(LCTRL) _(APPLICATION) _(LALT) _(SPACE) _(RALT) _(RCTRL) \
  _(UP) _(DOWN) _(LEFT) _(RIGHT) _(INSERT) _(DELETE) _(HOME) _(END) _(PAGEUP) _(PAGEDOWN)

#define KEY_NAMES(key) KEY_##key,
enum {
  KEY_NONE = 0,
  KEYS(KEY_NAMES)
};

// GPU

#define GPU_TEXTURE  1
#define GPU_SUBTREE  2
#define GPU_NULL     0xffffffff

typedef uint32_t gpuptr_t;

struct gpu_texturedesc {
  uint16_t w, h;
  gpuptr_t pixels;
} __attribute__((packed));

struct gpu_canvas {
  uint16_t type, w, h, x1, y1, w1, h1;
  gpuptr_t sibling;
  union {
    gpuptr_t child;
    struct gpu_texturedesc texture;
  };
} __attribute__((packed));

#endif


// DISK
uint64_t ramdisk_read(void *buf, uint64_t offset, uint64_t len);
uint64_t ramdisk_write(const void *buf, uint64_t offset, uint64_t len);