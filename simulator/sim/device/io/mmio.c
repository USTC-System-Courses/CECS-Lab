#include <stdbool.h>
#include "device/map.h"
#include "debug.h"

#define NR_MAP 16

static IOMap maps[NR_MAP] = {};
static int nr_map = 0;

static IOMap* fetch_mmio_map(paddr_t addr) {
  int mapid = find_mapid_by_addr(maps, nr_map, addr);
  return (mapid == -1 ? NULL : &maps[mapid]);
}

static void report_mmio_overlap(const char *name1, paddr_t l1, paddr_t r1,
    const char *name2, paddr_t l2, paddr_t r2) {
  panic("MMIO region %s@[" FMT_PADDR ", " FMT_PADDR "] is overlapped "
               "with %s@[" FMT_PADDR ", " FMT_PADDR "]", name1, l1, r1, name2, l2, r2);
}

static inline bool in_pmem(paddr_t addr) {
  return (addr >= CONFIG_MBASE) && (addr < (paddr_t)CONFIG_MBASE + CONFIG_MSIZE);
}

#define PMEM_LEFT  ((paddr_t)CONFIG_MBASE)
#define PMEM_RIGHT ((paddr_t)CONFIG_MBASE + CONFIG_MSIZE - 1)
#define RESET_VECTOR (PMEM_LEFT + CONFIG_PC_RESET_OFFSET)

/* device interface */
// add the spcae into mmio map, so cpu visit this space will jump to device handler
void add_mmio_map(const char *name, paddr_t addr, void *space, uint32_t len, io_callback_t callback) {
  assert(nr_map < NR_MAP);
  paddr_t left = addr, right = addr + len - 1;
  if (in_pmem(left) || in_pmem(right)) {
    report_mmio_overlap(name, left, right, "pmem", PMEM_LEFT, PMEM_RIGHT);
  }
  for (int i = 0; i < nr_map; i++) {
    if (left <= maps[i].high && right >= maps[i].low) {
      report_mmio_overlap(name, left, right, maps[i].name, maps[i].low, maps[i].high);
    }
  }

  maps[nr_map] = (IOMap){ .name = name, .low = addr, .high = addr + len - 1,
    .space = space, .callback = callback };
  Log("Add mmio map '%s' at [" FMT_PADDR ", " FMT_PADDR "]",
      maps[nr_map].name, maps[nr_map].low, maps[nr_map].high);

  nr_map ++;
}

/* bus interface */
word_t mmio_read(paddr_t addr, int len) {
  return map_read(addr, len, fetch_mmio_map(addr));
}

void mmio_write(paddr_t addr, int len, word_t data) {
  map_write(addr, len, data, fetch_mmio_map(addr));
}
