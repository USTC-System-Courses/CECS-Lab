#include <base.h>
#include <dev-mmio.h>

void __timer_init() {
}

void __timer_uptime(DEV_TIMER_UPTIME_T *uptime) {
  // Lab6 TODO: implement uptime MMIO
  // hint: use function `inl` and RTC_ADDR to access RTC MMIO
}

void __timer_rtc(DEV_TIMER_RTC_T *rtc) {
  // Lab6 TODO: implement RTC MMIO
  // hint: use function `inl` and RTC_ADDR with offset  to access RTC MMIO
}