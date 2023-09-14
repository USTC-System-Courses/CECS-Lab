#include <stdbool.h>
#include <device/map.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

static uint32_t *diskctl_port_base = NULL;
static FILE *ramdisk_fp = NULL;
uint8_t* guest_to_host(paddr_t paddr);
extern void (*difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction);
enum { DIFFTEST_TO_DUT, DIFFTEST_TO_REF };

void rw_disk(paddr_t offset, int len, bool is_write) {
  if (!is_write) return;
  
  uint32_t disk_addr = diskctl_port_base[0];
  uint32_t mem_addr = diskctl_port_base[1];
  uint32_t size = diskctl_port_base[2];

  if (diskctl_port_base[3] == 1) {
    // read
    fseek(ramdisk_fp, disk_addr, SEEK_SET);
    fread(guest_to_host(mem_addr), size, 1, ramdisk_fp);

    uint32_t *buf = (uint32_t *)guest_to_host(mem_addr);
    difftest_memcpy(CONFIG_MBASE, guest_to_host(CONFIG_MBASE), CONFIG_MSIZE, DIFFTEST_TO_REF);

  } else if (diskctl_port_base[3] == 2) {
    // write
    // in our app, we will not write disk
    // assert(0);
    fseek(ramdisk_fp, disk_addr, SEEK_SET);
    fwrite(guest_to_host(mem_addr), size, 1, ramdisk_fp);

  }
  diskctl_port_base[3] = 0;
}

void init_disk(const char *diskpath) {
  ramdisk_fp = fopen(diskpath, "r");
  if (ramdisk_fp == NULL) assert(0);

  diskctl_port_base = (uint32_t *)new_space(16);
  add_mmio_map("diskctl", CONFIG_DISK_CTL_MMIO, diskctl_port_base, 12, NULL); // disk_addr, mem_addr, size 

  add_mmio_map("diskrw", CONFIG_DISK_CTL_MMIO + 12, &diskctl_port_base[3], 4, rw_disk);
}
