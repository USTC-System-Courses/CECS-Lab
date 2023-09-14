#include <base.h>
#include <tool.h>

void __timer_init();
void __gpu_init();

void __timer_rtc    (DEV_TIMER_RTC_T *);
void __timer_uptime (DEV_TIMER_UPTIME_T *);
void __input_keybrd (DEV_INPUT_KEYBRD_T *);
void __timer_rtc    (DEV_TIMER_RTC_T *);
void __gpu_config   (DEV_GPU_CONFIG_T *);
void __gpu_status   (DEV_GPU_STATUS_T *);
void __gpu_fbdraw   (DEV_GPU_FBDRAW_T *);

void __timer_config (DEV_TIMER_CONFIG_T *cfg) { cfg->present = true; cfg->has_rtc = true; }
void __input_config (DEV_INPUT_CONFIG_T *cfg) { cfg->present = true;  }
void __uart_config  (DEV_UART_CONFIG_T *cfg)  { cfg->present = false; }

typedef void (*handler_t)(void *buf);
static void *lut[128] = {
  [DEV_TIMER_CONFIG] = __timer_config,
  [DEV_TIMER_RTC   ] = __timer_rtc,
  [DEV_TIMER_UPTIME] = __timer_uptime,
  [DEV_INPUT_CONFIG] = __input_config,
  [DEV_INPUT_KEYBRD] = __input_keybrd,
  [DEV_GPU_CONFIG  ] = __gpu_config,
  [DEV_GPU_FBDRAW  ] = __gpu_fbdraw,
  [DEV_GPU_STATUS  ] = __gpu_status,
  [DEV_UART_CONFIG ] = __uart_config,
};

static void fail(void *buf) { panic("unhandled ioe port"); }

bool ioe_init() {
  for (int i = 0; i < LENGTH(lut); i++)
      if (!lut[i]) lut[i] = fail;
  __timer_init();
  __gpu_init();
  return true;
}

void ioe_read (int reg, void *buf) { ((handler_t)lut[reg])(buf); }
void ioe_write(int reg, void *buf) { ((handler_t)lut[reg])(buf); }
