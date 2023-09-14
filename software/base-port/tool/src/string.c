#include <tool.h>
size_t strlen(const char *s) {
  size_t size = 0;
  while(*s) {
    s++;
    size++;
  } 
  return size;
}
size_t strnlen(const char *s, size_t count){
  const char *sc;
  for (sc = s; *sc != '\0' && count--; ++sc);
  return sc - s;
}

char *strcpy(char *dst, const char *src) {
  int i;
  for(i = 0; src[i]; i++) dst[i] = src[i];
  dst[i] = src[i];
  return dst;
}

char *strncpy(char *dst, const char *src, size_t n) {
  if(n < 0) return dst;
  for(int i = 0; i < n && src[i]; i++) dst[i] = src[i];
  return dst;
}

char *strcat(char *dst, const char *src) {
  int i = strlen(dst);
  for(int j = 0; src[j]; i++, j++) dst[i] = src[j];
  dst[i] = 0;
  return dst;
}

int strcmp(const char *s1, const char *s2) {
  int i;
  for(i = 0; s1[i] && s2[i]; i++){
    if(s1[i] > s2[i]) return 1;
    else if(s1[i] < s2[i]) return -1;
  }
  if(s1[i]) return 1;
  else if(s2[i]) return -1;
  else return 0;
}

int strncmp(const char *s1, const char *s2, size_t n) {
  if(n < 0) return 0;
  int i;
  for(i = 0; i < n && s1[i] && s2[i]; i++){
    if(s1[i] > s2[i]) return 1;
    else if(s1[i] < s2[i]) return -1;
  }
  if(i == n) return 0;
  else if(s1[i]) return 1;
  else return -1;
}

char* strchr(const char *s, int c) {
  while(*s){
    if(*s == c) return (char*)s;
    s++;
  }
  return NULL;
}

char* strrchr(const char *s, int c) {
  char *p = NULL;
  while(*s){
    if(*s == c) p = (char*)s;
    s++;
  }
  return p;
}

void *memset(void *s, int c, size_t n) {
  if(!s || n < 0) return NULL;
  unsigned char *p = (unsigned char*) s;
  for(int i = 0; i < n; i++) p[i]= (unsigned char) c;
  return s;
}

void *memmove(void *dst, const void *src, size_t n) {
  if(n < 0) return dst;
  unsigned char *q = (unsigned char*) src;
  unsigned char *p = (unsigned char*) dst;
  if(p < q){
    for(int i = 0; i < n; i++) p[i] = q[i];
  }
  else {
    while(n--){
      p[n] = q[n];
    }
  }
  return dst;
}

void *memcpy(void *out, const void *in, size_t n) {
  if(n < 0) return out;
  unsigned char *q = (unsigned char*) in;
  unsigned char *p = (unsigned char*) out;
  for(int i = 0; i < n; i++) p[i] = q[i];
  return out;
}

int memcmp(const void *s1, const void *s2, size_t n) {
  if(n < 0) return 0;
  int i;
  unsigned char *p = (unsigned char*)s1;
  unsigned char *q = (unsigned char*)s2;
  for(i = 0; i < n && p[i] && q[i]; i++){
    if(p[i] > q[i]) return 1;
    else if(p[i] < q[i]) return -1;
  }
  if(i == n) return 0;
  else if(p[i]) return 1;
  else return -1;
}