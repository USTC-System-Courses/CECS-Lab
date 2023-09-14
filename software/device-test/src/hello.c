#include <devtest.h>

void hello() {
  for (int i = 0; i < 10; i ++) {
    printf("%d: Hello, CECS 2023!\n", i);
  }
}

int main(const char *args){
  ioe_init();
  hello();
  return 0;
}