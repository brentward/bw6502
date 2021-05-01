AS = vasm6502_oldstyle
ASBIN	= -Fbin
ASOPTS = -dotdir -c02

all: clean build/main.bin

clean:
	rm -f build/main.bin

build/main.bin: main.s
	$(AS) $(ASBIN) $(ASOPTS) $< -o $@
