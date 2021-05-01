; MMIO
PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003
PRC = $600c
IFR = $600d
IER = $600e

;zero page variables
tmp1 = $23 ; 1 byte
tmp2 = $24 ; 1 byte
tmp3 = $25 ; 1 byte
tmp4 = $26 ; 1 byte
h_nib = $27 ; 1 byte, high nibble of LCD byte
l_nib = $28 ; 1 byte, low nibble of LCD byte

; variables
value = $0200 ; 2 bytes
mod10 = $0202 ; 2 bytes
message = $0204 ; 6 bytes
counter = $020a ; 2 bytes

E  = %10000000
RW = %01000000
RS = %00100000

  .org $8000

reset:
  sei
  ldx #$ff
  txs            ; Initialize stack pointer with ff (addr 0x01ff)

  lda #$82
  sta IER

  lda #$00
  sta PRC

  jsr via_init
  jsr lcd_init

  cli
  lda #0
  sta counter
  sta counter + 1

loop:
  lda #%00000010 ; Home
  jsr lcd_instruction

  lda #0
  sta message

  ; Init value to be the be number to convert
  sei
  lda counter
  sta value
  lda counter + 1
  sta value + 1
  cli

divide:
  ; Init the remainder to 0
  lda #0
  sta mod10
  sta mod10 + 1
  clc

  ldx #16
divloop:
  ; Rotate quotient and remainder
  rol value
  rol value + 1
  rol mod10
  rol mod10 + 1

  ; a,y = divident - devisor
  sec
  lda mod10
  sbc #10
  tay ; save low byte in y
  lda mod10 + 1
  sbc #0
  bcc ignore_result ; branch if divident < divisor
  sty mod10
  sta mod10 + 1

ignore_result:
  dex
  bne divloop
  rol value ; shift in the last bit of the quotient
  rol value + 1

  lda mod10
  clc
  adc #"0"
  jsr push_char

  ; if value != 0 then continue dividing
  lda value
  ora value + 1
  bne divide ; branch if value not 0

  ldx #0
print:
  lda message,x
  ; beq loop
  beq clear
  jsr print_char
  inx
  jmp print

clear:
  ldx #5
clear_loop:
  lda #" "
  jsr print_char
  dex
  bne clear_loop
  jmp loop

; Add the character in the a register to the beginning of the
; null-terminated string `message`
push_char:
  pha ; Push new first char onto stack
  ldy #0

char_loop:
  lda message,y ; Get char on string an put into x
  tax
  pla
  sta message,y ; Pull char off stack and add it to the string
  iny
  txa
  pha           ; Push char from string onto stack
  bne char_loop
  
  pla 
  sta message,y ; Pull the null off the stack and add to the end of the string

  rts

lcd_wait:
  pha
  lda #%11110000 ; Port B is input
  sta DDRB
lcd_busy:
  lda #RW
  sta PORTB
  lda #(RW | E)
  sta PORTB
  lda PORTB
  sta h_nib
  lda #RW
  sta PORTB
  lda #(RW | E)
  sta PORTB
  lda PORTB
  sta l_nib
  lda h_nib
  and #%00001000
  bne lcd_busy

  lda #RW
  sta PORTB
  lda #%11111111 ; Port B is output
  sta DDRB
  pla
  rts

lcd_instruction:
  jsr lcd_wait
lcd_send_command:
  pha
  lsr            ; shift high nibble to low 4 bits
  lsr
  lsr
  lsr
  ora #E         ; Sets E bit
  sta PORTB
  eor #E         ; Clear E bit
  sta PORTB
  pla
  and #%00001111 ; Mask high nibble
  ora #E         ; Sets E bit
  sta PORTB
  eor #E         ; Clear E bit
  sta PORTB
  rts

print_char:
  pha
  jsr lcd_wait
  lsr            ; shift high nibble to low 4 bits
  lsr
  lsr
  lsr
  ora #RS        ; Set RS, clear RW/E bits
  sta PORTB
  ora #E         ; Set E
  sta PORTB
  eor #E         ; Clear E
  sta PORTB
  pla
  and #%00001111 ; Mask high nibble
  ora #RS        ; Set RS, clear RW/E bits
  sta PORTB
  ora #E         ; Set E
  sta PORTB
  eor #E         ; Clear E
  sta PORTB
  rts

via_init:
  pha
  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
  lda #0
  sta PORTB      ; Set all pins on port B low
  pla
  rts

lcd_init:
  pha
  lda #50
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_send_command
  lda #5
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_send_command
  lda #1
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_send_command
  lda #1
  jsr wait_ms
  lda #%00000010 ; Sets to 4-bit mode
  jsr lcd_send_command
  lda #%00101000 ; Sets to 4-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00000110 ; Entry mode set; increment and shift cursor; no scroll 
  jsr lcd_instruction
  lda #%00000001 ; Clear display
  jsr lcd_instruction
  lda #%00001100 ; Display on; cursor on; blink off 
  jsr lcd_instruction
  pla
  rts

wait_ms:
  sta tmp1
  txa
  pha
  tya
  pha
  ldx tmp1

  ldy #190
wait_loop1:
  nop ; spin 2 cycles
  adc $00 ; spin 3 cycles
  dey
  bne wait_loop1

wait_loop2:
  dex
  beq wait_return
  
  nop
  ldy #198
wait_loop3:
  nop ; spin 2 cycles
  adc $00 ; spin 3 cycles
  dey
  bne wait_loop3

  jmp wait_loop2

wait_return:
  pla
  tay
  pla
  tax
  lda tmp1
  rts


nmi:
  rti

irq:
  pha
  inc counter
  bne exit_irq
  inc counter + 1
exit_irq:
  bit PORTA
  pla
  rti

  .org $fffa
  .word nmi
  .word reset
  .word irq
