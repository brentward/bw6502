PROJECT_NAME=bw6502
# cc65 utilities used in this example
CA65_BINARY=ca65
CC65_BINARY=cc65
LD65_BINARY=ld65
AR65_BINARY=ar65

CPU_FLAG=--cpu 65C02
ARCH_FLAG=-t none

CC65_FLAGS=$(CPU_FLAG) $(ACIA_FLAG) -O
CA65_FLAGS=$(CPU_FLAG) $(BUILD_FLAG) -g --feature labels_without_colons
LD65_FLAGS=-vm
AR65_FLAGS=r

# Checksum generator
MD5_BINARY=md5sum

# Standard utilities (rm/mkdir)
RM_BINARY=rm
MKDIR_BINARY=mkdir
MKDIR_FLAGS=-p
CP_BINARY=cp
CP_FLAGS=-f

# Include folders
SOURCE_FOLDER=src
BUILD_FOLDER=build
ROM_FOLDER=rom

# Common objects to be linked
SOURCES=	acia.s	\
			bw6502.s \
			ehbasic.s \
			keyboard.s \
			lcd.s \
			utils.s \
			via.s 

OBJECTS=$(SOURCES:%.s=$(BUILD_FOLDER)/%.o)

FIRMWARE_CFG=$(PROJECT_NAME).cfg
FIRMWARE_BINARY=$(ROM_FOLDER)/$(PROJECT_NAME).bin
FIRMWARE_MAP=$(ROM_FOLDER)/$(PROJECT_NAME).map

# basic.run:: basic.bin
# 	srec_cat basic.bin -binary -o basic.run
$(FIRMWARE_BINARY): $(OBJECTS)
	@$(MKDIR_BINARY) $(MKDIR_FLAGS) $(ROM_FOLDER)
	$(LD65_BINARY) $(LD65_FLAGS) -C $(FIRMWARE_CFG) -m $(FIRMWARE_MAP) -o $(FIRMWARE_BINARY) $^
# basic.bin: basic.o
# 	ld65 -C sbc.cfg -vm -m basic.map -o basic.bin basic.o


# Compile assembler sources
$(BUILD_FOLDER)/%.o: $(SOURCE_FOLDER)/%.s $(FIRMWARE_CFG)
	@$(MKDIR_BINARY) $(MKDIR_FLAGS) $(BUILD_FOLDER)
	$(CA65_BINARY) $(CA65_FLAGS) -o $@ -l $(@:.o=.lst) $<

# basic.o: basic.asm sbc_mon.asm
# 	ca65 -g -l basic.lst --feature labels_without_colons -o basic.o sbc_mon.asm

# Standard build
all: $(FIRMWARE_BINARY)

clean:
	$(RM) build/*.o build/*.lst build/*.map build/*.bin build/*.run build/*.mon build/*.c1p

