#include <base.h>
#include <dev-mmio.h>

#define KEYDOWN_MASK 0x8000

void __input_keybrd(DEV_INPUT_KEYBRD_T *kbd) {
  uint32_t data = inl(KBD_ADDR);
  kbd->keydown = (data & KEYDOWN_MASK) ? 1 : 0;
  kbd->keycode = data & ~KEYDOWN_MASK;
}