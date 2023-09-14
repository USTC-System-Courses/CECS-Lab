#ifndef TOOL_H__
#define TOOL_H__
#include <stddef.h>
#include <stdarg.h>
#include <base.h>
#include <dev.h>

#define ROUNDUP(a, sz)      ((((uintptr_t)a) + (sz) - 1) & ~((sz) - 1))
#define LENGTH(arr)         (sizeof(arr) / sizeof((arr)[0]))
#define STRINGIFY(s)        #s
#define TOSTRING(s)         STRINGIFY(s)

// string.h

void  *memset    (void *s, int c, size_t n);
void  *memcpy    (void *dst, const void *src, size_t n);
void  *memmove   (void *dst, const void *src, size_t n);
int    memcmp    (const void *s1, const void *s2, size_t n);
size_t strlen    (const char *s);
size_t strnlen   (const char *s, size_t count);
char  *strcat    (char *dst, const char *src);
char  *strcpy    (char *dst, const char *src);
char  *strncpy   (char *dst, const char *src, size_t n);
int    strcmp    (const char *s1, const char *s2);
int    strncmp   (const char *s1, const char *s2, size_t n);
char  *strchr    (const char *s, int c);
char  *strrchr   (const char *s, int c);

// stdio.h
int    printf    (const char *format, ...);
int    sprintf   (char *str, const char *format, ...);
int    snprintf  (char *str, size_t size, const char *format, ...);
int    vsprintf  (char *str, const char *format, va_list ap);
int    vsnprintf (char *str, size_t size, const char *format, va_list ap);


#define panic_on(cond, s) \
  ({ if (cond) { \
      putstr("Panic: "); putstr(s); \
      putstr(" @ " __FILE__ ":" TOSTRING(__LINE__) "  \n"); \
      halt(1); \
    } })

#define panic(s) panic_on(1, s)

#define assert(cond) \
  do { \
    if (!(cond)) { \
      printf("Assertion fail at %s:%d\n", __FILE__, __LINE__); \
      halt(1); \
    } \
  } while (0)

#endif

