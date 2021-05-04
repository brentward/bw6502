AS = vasm6502_oldstyle
ASBIN = -Fbin
ASOPTS = -dotdir -wdc02 -opt-branch

all: clean build/main.bin

clean:
	mkdir -p build
	rm -f build/main.bin

build/main.bin: src/main.s
	$(AS) $(ASBIN) $(ASOPTS) $< -o $@
