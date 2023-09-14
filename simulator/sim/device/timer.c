#include "device/map.h"
#include <stdbool.h>
#include <time.h>
static uint32_t *rtc_port_base = NULL;

static void rtc_io_handler(uint32_t offset, int len, bool is_write) {
  assert(!is_write);
  uint64_t us = get_time();
  struct tm* rtc = get_time_tm();
  rtc_port_base[0] = (uint32_t)us;
  rtc_port_base[1] = us >> 32;
  rtc_port_base[2] = rtc->tm_sec;
  rtc_port_base[3] = rtc->tm_min;
  rtc_port_base[4] = rtc->tm_hour;
  rtc_port_base[5] = rtc->tm_mday;
  rtc_port_base[6] = rtc->tm_mon + 1;
  rtc_port_base[7] = rtc->tm_year + 1900;
}

void init_timer() {
  rtc_port_base = (uint32_t *)new_space(32);
  add_mmio_map("rtc", CONFIG_RTC_MMIO, rtc_port_base, 32, rtc_io_handler);
}
