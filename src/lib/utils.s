wait_ms:
  sta r0
  phx
  phy
  ldx r0

  ldy #190
.loop1:
  nop ; spin 2 cycles
  adc $00 ; spin 3 cycles
  dey
  bne .loop1

.loop2:
  dex
  beq .return
  
  nop
  ldy #198
.loop3:
  nop ; spin 2 cycles
  adc $00 ; spin 3 cycles
  dey
  bne .loop3

  jmp .loop2

.return:
  ply
  plx
  lda r0
  rts
