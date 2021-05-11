  .org $8000

  .include lib/lcd.s
  .include lib/decimal.s
  .include lib/via.s
  .include lib/keyboard.s
  .include lib/utils.s
  .include lib/zeropage.s

; variables
kb_buffer = $0300 ; 256 bytes 0x0200-0x02ff
screen_buf = $0400 ; 256 bytes 0x0300-0x03ff
decimal_string = $0500 ; 6 bytes 0x0400-0x0405

reset:
  sei
  ldx #$ff
  txs            ; Initialize stack pointer with ff (addr 0x01ff)

  jsr via_init
  jsr lcd_init
  jsr kb_init
  jsr via_led_array_init

  cli

loop:
  sei
  lda kb_rptr
  cmp kb_wptr
  cli
  bne key_pressed

  jmp loop

key_pressed:
  jsr via_led_right
  ldx kb_rptr
  lda kb_buffer,x
  jsr lcd_print_char
  inc kb_rptr
  jmp loop


nmi:
  rti

irq:
  jsr kb_handle
  rti

  .org $fffa
  .word nmi
  .word reset
  .word irq
