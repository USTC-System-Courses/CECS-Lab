#include <stdbool.h>
#include "common.h"
#include <SDL2/SDL.h>


void init_map();
void init_serial();
void init_timer();
void init_vga();
void init_i8042();
void init_disk(const char *diskpath);

void send_key(uint8_t, bool);
void vga_update_screen();

#define TIMER_HZ 60

void device_update() {
  static uint64_t last = 0;
  uint64_t now = get_time();
  if (now - last < 100000 / TIMER_HZ) {
    return;
  }
  last = now;

  vga_update_screen();

  SDL_Event event;
  while (SDL_PollEvent(&event)) {
    switch (event.type) {
      case SDL_QUIT:
        sim_state.state = SIM_QUIT;
        break;
      //If a key was pressed
      case SDL_KEYDOWN:
      case SDL_KEYUP: {
        uint8_t k = event.key.keysym.scancode;
        bool is_keydown = (event.key.type == SDL_KEYDOWN);
        send_key(k, is_keydown);
        break;
      }
      default: break;
    }
  }
}

void sdl_clear_event_queue() {
  SDL_Event event;
  while (SDL_PollEvent(&event));
}

void init_device(const char *diskpath) {
  init_map();

  init_serial();
  init_timer();
  init_vga();
  // keyboard
  init_i8042();

  // printf("disk path = %s\n", diskpath);
  if (strcmp(diskpath, " ") != 0) init_disk(diskpath);
}
