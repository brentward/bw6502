# Adjust the run address to match the .org in the source code

bw6502.run:: bw6502.bin
	srec_cat bw6502.bin -binary -o bw6502.run

bw6502.bin: bw6502.o
	ld65 -C bw6502.cfg -vm -m bw6502.map -o bw6502.bin bw6502.o

bw6502.o: bw6502.s basic.s acia.s via.s lcd.s
	ca65 -g -l bw6502.lst --feature labels_without_colons -o bw6502.o bw6502.s

clean:
	$(RM) *.o *.lst *.map *.bin *.run *.mon *.c1p

distclean: clean
