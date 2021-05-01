  .org $8000

  .include lib/lcd.s
  .include lib/decimal.s
  .include lib/via.s
  .include lib/keyboard.s
  .include lib/utils.s
  .include lib/zeropage.s

; variables
counter = $0204 ; 2 bytes
message = $0206 ; 81 bytes 0x0206..0x0257
decimal_string = $2057 ; 6 bytes 0x2057..0x205d


reset:
  sei
  ldx #$ff
  txs            ; Initialize stack pointer with ff (addr 0x01ff)

  jsr via_init
  jsr lcd_init

  cli
  stz counter
  stz counter + 1
  stz ps2_ignore_next_code

loop:
  bra loop

nmi:
  rti

irq:
  pha
  lda VIA1_PORTA
  jsr print_ps2_key
  ; sta counter
  pla
  rti

  .org $fffa
  .word nmi
  .word reset
  .word irq
