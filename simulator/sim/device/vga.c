#include <stdbool.h>
#include "device/map.h"

#define SCREEN_W 400
#define SCREEN_H 300

static uint32_t screen_width() {
  return SCREEN_W;
}

static uint32_t screen_height() {
  return SCREEN_H;
}

static uint32_t screen_size() {
  return screen_width() * screen_height() * sizeof(uint32_t);
}

static void *vmem = NULL;
static uint32_t *vgactl_port_base = NULL;

#include <SDL2/SDL.h>

static SDL_Renderer *renderer = NULL;
static SDL_Texture *texture = NULL;

static void init_screen() {
  SDL_Window *window = NULL;
  char title[128];
  sprintf(title, "riscv32-NPC");
  SDL_Init(SDL_INIT_VIDEO);
  SDL_CreateWindowAndRenderer(
      SCREEN_W * 2,
      SCREEN_H * 2,
      0, &window, &renderer);
  SDL_SetWindowTitle(window, title);
  texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_ARGB8888,
      SDL_TEXTUREACCESS_STATIC, SCREEN_W, SCREEN_H);
}

static inline void update_screen() {
  SDL_UpdateTexture(texture, NULL, vmem, SCREEN_W * sizeof(uint32_t));
  SDL_RenderClear(renderer);
  SDL_RenderCopy(renderer, texture, NULL, NULL);
  SDL_RenderPresent(renderer);
}

void vga_update_screen() {
  if (vgactl_port_base[1] != 0) {
    update_screen();
    vgactl_port_base[1] = 0;
  }
}

// fast render
static uint32_t *ffb_mem = NULL;
static void *ffb_draw = NULL;

void fast_fb_draw(paddr_t offset, int len, bool is_write) {
  assert(is_write);
  uint32_t *fb = (uint32_t *)vmem;
  uint32_t x = ffb_mem[0];
  uint32_t y = ffb_mem[1];
  uint32_t w = ffb_mem[2];
  uint32_t h = ffb_mem[3];
  uint32_t W = ffb_mem[4];
  uint32_t H = ffb_mem[5];
  uint32_t *pixels = (uint32_t *)guest_to_host(ffb_mem[6]);

  uint32_t h_real = y + h > H ? (y > H ? 0: H - y) : h;
  uint32_t w_real = x + w > W ? W - x : w;
  for(int i = 0; i < h_real; i++){
    // memcpy(fb + (y + i) * W + x, pixels + i * w, w_real * sizeof(uint32_t));
    for(int j = 0; j < w_real; j++){
      fb[(y + i) * W + x + j] = pixels[i * w + j];
    }
  }
}

void init_vga() {
  // alloc a memory space
  vgactl_port_base = (uint32_t *)new_space(8);
  vgactl_port_base[0] = (screen_width() << 16) | screen_height();
  add_mmio_map("vgactl", CONFIG_VGA_CTL_MMIO, vgactl_port_base, 8, NULL);

  vmem = new_space(screen_size());
  add_mmio_map("vmem", CONFIG_FB_ADDR, vmem, screen_size(), NULL);
  init_screen();
  memset(vmem, 0, screen_size());

  // fast fb draw
  ffb_mem = (uint32_t *)new_space(28); // x, y, w, h, W, H, pixels
  add_mmio_map("ffb_mem", CONFIG_FFB_ADDR, ffb_mem, 28, NULL);

  ffb_draw = (uint32_t *)new_space(4);
  add_mmio_map("ffb_draw", CONFIG_FFB_ADDR + 28, ffb_draw, 4, fast_fb_draw);
}
