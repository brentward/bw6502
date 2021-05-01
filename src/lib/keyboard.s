print_ps2_key:
  bit ps2_ignore_next_code
  bmi .code_ignored

  cmp #$f0
  beq .ignore_next

  cmp #$5f
  bpl .too_high

  tax
  lda ps2_scan_codes,x
  jsr print_char
  rts
.too_high:
  rts
.ignore_next:
  lda #$FF
  sta ps2_ignore_next_code
  rts
.code_ignored:
  stz ps2_ignore_next_code
  rts

push_char:
  pha
  ldx #0

.char_loop
  lda message,x
  beq .add_char
  inx
  jmp .char_loop

.add_char
  pla
  sta message,x
  inx
  stz message,x
  rts


  .align 8
ps2_scan_codes:
  ;     0123456789ABCDEF
  .asc "??????????????`?" ; 0
  .asc "?????Q1???ZSAW2?" ; 1
  .asc "?CXDE43?? VFTR5?" ; 2
  .asc "?NBHGY6???MJU78?" ; 3
  .asc "?,KIO09??./L;P-?" ; 4
  .asc "??'?[=?????]?\??" ; 5

