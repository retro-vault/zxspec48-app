# We only allow compilation on linux!
ifneq ($(shell uname), Linux)
$(error OS must be Linux!)
endif

# Check if all required tools are on the system.
REQUIRED = sdcc sdasz80 sdldz80 sdobjcopy sed
K := $(foreach exec,$(REQUIRED),\
    $(if $(shell which $(exec)),,$(error "$(exec) not found. Please install or add to path.")))

# Directories.
BUILD_DIR   =   build
INC_DIR     =   . include
LIB_DIR     =   lib

# Virtual paths are all subfolders!
SDIRS       =   src
vpath %.c $(SDIRS)
vpath %.s $(SDIRS)
vpath %.h $(SDIRS)

# Source files and the target.
APP         =   app
ADDR        =   0x8000
CRT0        =   crt0
C_SRCS      =   $(wildcard */*.c)
S_SRCS      =   $(filter-out $(SDIRS)/$(CRT0).s, $(wildcard */*.s))
OBJS        =   $(addprefix $(BUILD_DIR)/, \
                    $(notdir \
                        $(patsubst %.c,%.rel,$(C_SRCS)) \
                        $(patsubst %.s,%.rel,$(S_SRCS)) \
                    ) \
                )

# Tools.
CC          =   sdcc
CFLAGS      =   --std-c11 -mz80 --debug --nostdinc \
                $(addprefix -I,$(INC_DIR))
AS          =   sdasz80
ASFLAGS     =   -xlos -g
LD          =   sdcc
LDFLAGS     =   -mz80 -Wl -y --code-loc $(ADDR) \
                --no-std-crt0 --nostdlib --nostdinc \
                $(addprefix -L,$(LIB_DIR)) \
                -llibsdcc-z80 -p
OBJCOPY     =   sdobjcopy
# Data segment fix (relink due to SDCC bug)
L2          =   sdldz80
L2FLAGS     =   -nf
L2FIX       =   sed '/-b _DATA = $(ADDR)/d'
# File
RMDIR       =   rm -f -r 
MKDIR       =   mkdir -p 

# Rules.
.PHONY: all
all: $(BUILD_DIR) $(BUILD_DIR)/$(APP).bin

.PHONY: $(BUILD_DIR)
$(BUILD_DIR):
	# Remove build dir (we are going to write again).
	$(RMDIR) $(BUILD_DIR)
	# And re-create!
	$(MKDIR) $(BUILD_DIR)

$(BUILD_DIR)/$(APP).bin: $(BUILD_DIR)/$(APP).ihx
	$(OBJCOPY) -I ihex -O binary $(basename $@).ihx $(basename $@).bin

$(BUILD_DIR)/$(APP).ihx: $(BUILD_DIR)/$(CRT0).rel $(OBJS)
	$(LD) $(LDFLAGS) -o $(BUILD_DIR)/$(APP).ihx \
		$(BUILD_DIR)/$(CRT0).rel $(OBJS)
	$(L2FIX) $(BUILD_DIR)/$(APP).lk > $(BUILD_DIR)/$(APP).link
	$(L2) $(L2FLAGS) $(BUILD_DIR)/$(APP).link

$(BUILD_DIR)/%.rel: %.c
	$(CC) -c -o $(BUILD_DIR)/$(@F) $< $(CFLAGS)

$(BUILD_DIR)/%.rel: %.s
	$(AS) $(ASFLAGS) $(BUILD_DIR)/$(@F) $<

$(BUILD_DIR)/$(CRT0).rel: $(CRT0).s
	$(AS) $(ASFLAGS) $(BUILD_DIR)/$(@F) $<

.PHONY: clean
clean:
	$(RMDIR) $(BUILD_DIR)