#include <tool.h>
#include <dev-mmio.h>

/* read `len' bytes starting from `offset' of ramdisk into `buf' */
uint64_t ramdisk_read(void *buf, uint64_t offset, uint64_t len) {
  uint32_t *diskctl = (uint32_t *)DISK_CTL_ADDR;
  
  diskctl[0] = (uint32_t)offset;
  diskctl[1] = (uint32_t)buf;
  diskctl[2] = (uint32_t)len;
  asm volatile("fence iorw, iorw");
  diskctl[3] = 1;

  return len;
}

/* write `len' bytes starting from `buf' into the `offset' of ramdisk */
uint64_t ramdisk_write(const void *buf, uint64_t offset, uint64_t len) {
  uint32_t *diskctl = (uint32_t *)DISK_CTL_ADDR;

  diskctl[0] = (uint32_t)offset;
  diskctl[1] = (uint32_t)buf;
  diskctl[2] = (uint32_t)len;
  asm volatile("fence.i");
  diskctl[3] = 2;
  
  return len;
}
