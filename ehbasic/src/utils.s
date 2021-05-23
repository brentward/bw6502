.segment "BIOS"

wait_ms:
  sta r0
  phx
  phy
  ldx r0

  ldy #190
wait_ms_loop1:
  nop ; spin 2 cycles
  adc $00 ; spin 3 cycles
  dey
  bne wait_ms_loop1

wait_ms_loop2:
  dex
  beq wait_ms_return
  
  nop
  ldy #198
wait_ms_loop3:
  nop ; spin 2 cycles
  adc $00 ; spin 3 cycles
  dey
  bne wait_ms_loop3

  jmp wait_ms_loop2

wait_ms_return:
  ply
  plx
  lda r0
  rts
