ARGS ?= -b

APP ?= hello
APP_IMG = $(addprefix $(TEST_DIR)/app/, $(addsuffix -riscv32-nemu.bin, $(APP)))
IMG ?= $(APP_IMG)


$(VBIN): $(CSRC) $(VSRC)
	@echo "$(COLOR_YELLOW)[VERILATE]$(COLOR_NONE) $(notdir $(OBJ_DIR))/VCPU"
	@verilator $(VFLAGS) $(CSRC) $(CINC_PATH) $(VERILOG_TOP)
	@make -s -C $(OBJ_DIR) -f $(REWRITE)

$(NEMUISO):
	@echo "$(COLOR_YELLOW)[Make DIFF]$(COLOR_NONE) $(notdir $(NEMU_DIR))/build/riscv32-nemu-interpreter-so"
	@make -s -C $(NEMU_DIR)

run: $(VBIN) $(NEMUISO) $(IMG)
	@echo "$(COLOR_YELLOW)[Run IMG]$(COLOR_NONE)" $(notdir $(IMG))
	@$(VBIN) $(IMG) $(NEMUISO) $(ARGS)

gdb: $(VBIN) $(NEMUISO) $(IMG)
	@echo "$(COLOR_YELLOW)[GDB IMG]$(COLOR_NONE)" $(notdir $(IMG))
	@gdb -s $(VBIN) --args $(VBIN) $(IMG) $(NEMUISO) $(ARGS)

app: $(VBIN) $(APP_IMG) $(NEMUISO)
	@$(VBIN) $(APP_IMG) $(NEMUISO) $(ARGS)

clean:
	@echo rm -rf OBJ_DIR *vcd
	@rm -rf $(OBJ_DIR)
	@rm -rf *.vcd
clean-all:
	@echo rm -rf OBJ_DIR *vcd NEMU_DIFF
	@rm -rf $(OBJ_DIR)
	@rm -rf *.vcd
	@make -s -C $(NEMU_DIR) clean

.PHONY: test test_all clean
