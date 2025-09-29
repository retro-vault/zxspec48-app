# src/Makefile — ZX Spectrum SDCC build (crt0 first, .lk linker file, TAP output)

# -------- paths (we run as: make -C src ...) --------
SRC_DIR    := .
BUILD_ROOT := ../build
BIN_DIR    := ../bin

# target comes from the top Makefile (e.g., TARGET=zxspec48-app)
BUILD_DIR  := $(BUILD_ROOT)/$(TARGET)
OUT_BASE   := $(BUILD_DIR)/$(TARGET)

# -------- zx params --------
# Load/entry address (hex for linker, dec for bin2tap)
LOAD_ADDR_HEX ?= 0x8000
LOAD_ADDR_DEC ?= 32768

# TAP filename (output)
TAP := $(BIN_DIR)/$(TARGET).tap

# -------- tools --------
CC       := sdcc
AS       := sdasz80
LD       := sdldz80
OBJCOPY  := sdobjcopy
BIN2TAP  := bin2tap

# -------- compile / assemble flags (sdcc-style like your working makefile) --------
CFLAGS   := --std-c11 -mz80 --debug \
            --no-std-crt0 --nostdinc --nostdlib \
            -I. -I../include
ASFLAGS  := -plosgff

# -------- optional libraries (list concrete .lib files; paths will be relativized in .lk) --------
# Example:
# LIBS     := ../bin/libsdcc-z80.lib
# LIBDIRS  := ../bin
LIBS    ?=
LIBDIRS ?=

# -------- sources (crt0 first; then other .s/.c; mirror subdirs under BUILD_DIR) --------
# Pick the first crt0*.s in src/ (e.g., crt0.s or crt0_zx.s)
CRT0_SRC := $(firstword $(wildcard $(SRC_DIR)/crt0*.s))
CRT0_OBJ := $(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.rel,$(CRT0_SRC))

# Other sources (exclude crt0)
S_SRCS   := $(filter-out $(CRT0_SRC), $(wildcard $(SRC_DIR)/*.s) $(wildcard $(SRC_DIR)/zx/*.s))
C_SRCS   := $(wildcard $(SRC_DIR)/*.c)  $(wildcard $(SRC_DIR)/zx/*.c)

S_OBJS   := $(patsubst $(SRC_DIR)/%.s,$(BUILD_DIR)/%.rel,$(S_SRCS))
C_OBJS   := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.rel,$(C_SRCS))
OBJS     := $(S_OBJS) $(C_OBJS)

# -------- outputs --------
IHX     := $(OUT_BASE).ihx
BIN     := $(OUT_BASE).bin
LINKFK  := $(OUT_BASE).lk
MAP     := $(OUT_BASE).map

# -------- default --------
all: $(TAP)
	@echo "ok: $(notdir $(BIN))  ->  $(notdir $(TAP))"

# -------- link via generated .lk (like your earlier example) --------
$(IHX): $(CRT0_OBJ) $(OBJS)
	@mkdir -p $(BUILD_DIR)
	@echo "[link] generating $(LINKFK)"
	@{ \
	  echo "-b_CODE=$(LOAD_ADDR_HEX)"; \
	  echo "-b_DATA=0x9000"; \
	  echo "-b_BSS=0x9800"; \
	  echo "-i"; \
	  echo "-m"; \
	  echo "-j"; \
	  echo "-o $(notdir $(TARGET)).ihx"; \
	  for d in $(LIBDIRS); do echo "-L$${d}"; done; \
	  echo "$$(realpath --relative-to=$(BUILD_DIR) $(CRT0_OBJ))"; \
	  for obj in $(OBJS); do echo "$$(realpath --relative-to=$(BUILD_DIR) $$obj)"; done; \
	  for lib in $(LIBS); do echo "$$(realpath --relative-to=$(BUILD_DIR) $$lib)"; done; \
	} > $(LINKFK)
	@echo "[link] sdldz80 -f $(notdir $(LINKFK))"
	@cd $(BUILD_DIR) && $(LD) -f $(notdir $(LINKFK))
	@[ -f "$(BUILD_DIR)/$(TARGET).map" ] && mv -f "$(BUILD_DIR)/$(TARGET).map" "$(MAP)" || true

# -------- ihx -> bin --------
$(BIN): $(IHX)
	@mkdir -p $(dir $@)
	@echo "[objcopy] $(notdir $@)"
	@$(OBJCOPY) -I ihex -O binary $< $@

# -------- bin -> tap --------
$(TAP): $(BIN)
	@mkdir -p $(BIN_DIR)
	$(BIN2TAP) -b -o "$@" -a $(LOAD_ADDR_DEC) "$<"

# -------- build rules (preserve subdirs) --------
# Assemble crt0 first
$(CRT0_OBJ): $(CRT0_SRC)
	@mkdir -p $(dir $@)
	@echo "[as] $< -> $@"
	@$(AS) $(ASFLAGS) -o $@ $<

# Assemble any .s -> .rel
$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	@echo "[as] $< -> $@"
	@$(AS) $(ASFLAGS) -o $@ $<

# Compile any .c -> .rel
$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@echo "[cc] $< -> $@"
	@$(CC) $(CFLAGS) -c -o $@ $<

# -------- utilities --------
clean:
	@echo "[clean] removing $(BUILD_DIR)"
	@rm -rf "$(BUILD_DIR)"
	@echo "[clean] removing $(BIN_DIR)"
	@rm -rf "$(BIN_DIR)"

.PHONY: all clean
