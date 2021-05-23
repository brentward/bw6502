# Adjust the run address to match the .org in the source code

all: clean build/bw6502.bin


build/bw6502.run:: build/bw6502.bin
	srec_cat build/bw6502.bin -binary -o build/bw6502.run

build/bw6502.bin: build/bw6502.o
	ld65 -C bw6502.cfg -vm -m build/bw6502.map -o build/bw6502.bin build/bw6502.o

build/bw6502.o: src/bw6502.s
	ca65 -g -l build/bw6502.lst --feature labels_without_colons -o build/bw6502.o src/bw6502.s

clean:
	$(RM) build/*.o build/*.lst build/*.map build/*.bin build/*.run build/*.mon build/*.c1p

distclean: clean
