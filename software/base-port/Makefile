-include $(BASE_PORT)/script/riscv32.mk
ifeq ($(MAKECMDGOALS),)
  MAKECMDGOALS  = image
  .DEFAULT_GOAL = image
endif
# Compilers
CC 			= $(CROSS_COMPILE)gcc
CXX 		= $(CROSS_COMPILE)g++
AS 			= $(CROSS_COMPILE)gcc
LD 			= $(CROSS_COMPILE)ld
OBJ_DUMP 	= $(CROSS_COMPILE)objdump
OBJ_COPY 	= $(CROSS_COMPILE)objcopy

# include 
WORK_DIR  = $(abspath .)
INC_PATH = -I$(WORK_DIR)/include
INC_PATH += -I$(BASE_PORT)/base/include
INC_PATH += -I$(BASE_PORT)/tool/include

# FLAGS and LIBS
CFLAGS    += -O3 -Wall -Werror $(INC_PATH) -Wno-main -fno-asynchronous-unwind-tables -fno-builtin -fno-stack-protector -MMD
AFLAGS 	  += -MMD $(INC_PATH) 
LDFLAGS   += -T $(BASE_PORT)/script/linker.ld --defsym=_pmem_start=0x80000000 --defsym=_entry_offset=0x0 
LIBS 	  += $(BASE_PORT)/base/build/libbase.a $(BASE_PORT)/tool/build/libtool.a
LINKAGE   = $(OBJS) $(LIBS)

# Build directory and OBJS
BUILD_DIR = $(abspath ./build)
IMAGE ?= $(BUILD_DIR)/$(NAMES)-riscv32
TAR_DIR = $(BUILD_DIR)/riscv32
OBJS = $(addprefix $(TAR_DIR)/, $(addsuffix .o, $(basename $(SRCS))))

# Colors
COLOR_RED   		= \033[1;31m
COLOR_GREEN 		= \033[1;32m
COLOR_YELLOW 		= \033[33m
COLOR_NONE  		= \033[0m

# Compile C to object file
## Lab1 TODO: add C compile rule

# Compile assembly to object file
$(TAR_DIR)/%.o: %.S
	@mkdir -p $(dir $@) && echo "$(COLOR_YELLOW)[AS]$(COLOR_NONE) $<"
	@$(AS) $(AFLAGS) -c -o $@ $(realpath $<)

# make libbase
$(LIBS):
	@make -s -C $(BASE_PORT)/base libkernel
	@make -s -C $(BASE_PORT)/tool libkernel

# Linkage
$(IMAGE).elf: $(OBJS) $(LIBS)
	@echo "$(COLOR_YELLOW)[LD]$(COLOR_NONE) build/$(notdir $@)" 
	@$(LD) $(LDFLAGS) -o $@ --start-group $(LINKAGE) --end-group
## Lab1 TODO: add disassemble command here
	
	@$(OBJ_COPY) -O binary $@ $(IMAGE).bin

image: $(IMAGE).elf

run: image
	@make -s -C $(SIM_PATH) run IMG=$(IMAGE).bin ARGS=$(ARGS)

gdb: image
	@make -s -C $(SIM_PATH) gdb IMG=$(IMAGE).bin ARGS=$(ARGS)

clean: 
	rm -rf $(BUILD_DIR)
clean-all:
	rm -rf $(BUILD_DIR) $(BASE_PORT)/*/build
