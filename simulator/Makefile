OBJ_DIR   			= $(abspath ./build)
CSRC_DIR 			= $(abspath ./sim)
VSRC_DIR 			= $(abspath ./IP/mycpu)
NEMU_DIR 			= $(abspath ./nemu)
TEST_DIR 			= $(abspath ./testcases)

VERILOG_TOP 		= $(VSRC_DIR)/CPU.sv
NEMUISO 			= $(NEMU_DIR)/build/riscv32-nemu-interpreter-so
VFLAGS 				= --trace --cc --exe -O3 --threads-dpi all -I$(VSRC_DIR) -Mdir $(OBJ_DIR) -DDIFF
CINC_PATH 			= -CFLAGS -I$(CSRC_DIR)/include 
CSRC 				= $(shell find $(CSRC_DIR) -name "*.c*")
VSRC 				= $(shell find $(VSRC_DIR) -name "*.sv")
VBIN 				=  $(OBJ_DIR)/$(addprefix V, $(basename $(notdir $(VERILOG_TOP))))
REWRITE 			= $(abspath ./script/rewrite.mk)


COLOR_RED   		= \033[1;31m
COLOR_GREEN 		= \033[1;32m
COLOR_YELLOW 		= \033[33m
COLOR_NONE  		= \033[0m
include ./script/build.mk

