# src/Makefile — ZX Spectrum SDCC build with default linker/libs

SRC_DIR    := .
BUILD_ROOT := ../build
BIN_DIR    := ../bin

BUILD_DIR := $(BUILD_ROOT)/$(TARGET)
OUT_BASE  := $(BUILD_DIR)/$(TARGET)

# Load address used by SDCC link and TAP wrapper.
LOAD_ADDR_HEX ?= 0x8000
# bin2tap needs decimal; derive it from LOAD_ADDR_HEX automatically.
LOAD_ADDR_DEC ?= $(shell printf '%d\n' $(LOAD_ADDR_HEX))

CC      := sdcc
AS      := sdasz80
OBJCOPY := sdobjcopy
BIN2TAP := bin2tap

CFLAGS    := --std-c11 -mz80 --debug --no-std-crt0 -I. -I../include
LINKFLAGS := -mz80 --no-std-crt0 --code-loc $(LOAD_ADDR_HEX)
ASFLAGS   := -plosgff

C_SRCS := $(wildcard $(SRC_DIR)/*.c)
S_SRCS := $(wildcard $(SRC_DIR)/*.s)

C_OBJS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.rel,$(C_SRCS))
S_OBJS := $(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.rel,$(S_SRCS))
OBJS   := $(S_OBJS) $(C_OBJS)

IHX := $(OUT_BASE).ihx
BIN := $(OUT_BASE).bin
TAP := $(BIN_DIR)/$(TARGET).tap

all: $(TAP)
	@echo "ok: $(notdir $(BIN)) -> $(notdir $(TAP))"

$(IHX): $(OBJS)
	@mkdir -p $(BUILD_DIR)
	@echo "[link] $(notdir $@)"
	@$(CC) $(LINKFLAGS) -o $@ $(OBJS)

$(BIN): $(IHX)
	@mkdir -p $(dir $@)
	@echo "[objcopy] $(notdir $@)"
	@$(OBJCOPY) -I ihex -O binary $< $@

$(TAP): $(BIN)
	@mkdir -p $(BIN_DIR)
	@$(BIN2TAP) -b -o "$@" -a $(LOAD_ADDR_DEC) "$<"

$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@echo "[cc] $< -> $@"
	@$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	@echo "[as] $< -> $@"
	@$(AS) $(ASFLAGS) -o $@ $<

clean:
	@echo "[clean] removing $(BUILD_DIR)"
	@rm -rf "$(BUILD_DIR)"
	@echo "[clean] removing $(BIN_DIR)"
	@rm -rf "$(BIN_DIR)"

.PHONY: all clean
