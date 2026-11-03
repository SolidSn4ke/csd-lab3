# SDK-1.1M / STM32F427VIT6

.DEFAULT_GOAL := all

BUILD_DIR := Debug
PROJECT   := csd-lab3
ELF       := $(BUILD_DIR)/$(PROJECT).elf

OPENOCD     := openocd
OPENOCD_CFG := SDK1_1_M FTDBG.cfg
TARGET      := STM32F427VITx.cpu
JTAG_SPEED  ?= 500
JOBS        ?= $(shell nproc)

OPENOCD_SCRIPT = $(TARGET) configure -event reset-start {adapter speed $(JTAG_SPEED)}; $(TARGET) configure -event reset-init {adapter speed $(JTAG_SPEED)}; program $(ELF) verify reset exit

.PHONY: all build flush flush-only clean rebuild

all: build

build:
	$(MAKE) -C $(BUILD_DIR) -j$(JOBS) all

flush: build
	$(MAKE) flush-only

flush-only:
	@test -f "$(ELF)" || { echo "Firmware $(ELF) not found. Run 'make' first." >&2; exit 1; }
	$(OPENOCD) -s . -f '$(OPENOCD_CFG)' -c '$(OPENOCD_SCRIPT)'

clean:
	$(MAKE) -C $(BUILD_DIR) clean

rebuild:
	$(MAKE) clean
	$(MAKE) build

