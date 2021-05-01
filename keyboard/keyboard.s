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
lcd_addr = $27 ; 1 byte, lcd busy flag and address
ps2_ignore_next_code = $29 ; 1 byte
ps2_modifiers = $2a ; 1 byte ; na,na,na,na,caps,ctrl,alt,shift

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

  lda #$01
  sta PRC

  jsr via_init
  jsr lcd_init

  cli
  stz counter
  stz counter + 1
  stz ps2_ignore_next_code
  ; lda #0
  ; sta counter
  ; sta counter + 1

loop:
  bra loop

  ldx #0
print:
  lda message,x
  beq loop
;   beq clear
  jsr print_char
  inx
  jmp print

; clear:
;   ldx #5
; clear_loop:
;   lda #" "
;   jsr print_char
;   dex
;   bne clear_loop
;   jmp loop

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

lcd_init:
  pha
  lda #50
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_send_byte
  lda #5
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_send_byte
  lda #1
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_send_byte
  lda #1
  jsr wait_ms
  lda #%00000010 ; Sets to 4-bit mode
  jsr lcd_send_byte
  lda #%00101000 ; Sets to 4-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00000110 ; Entry mode set; increment and shift cursor; no scroll 
  jsr lcd_instruction
  lda #%00000001 ; Clear display
  jsr lcd_instruction
  lda #%00001111 ; Display on; cursor on; blink on 
  jsr lcd_instruction
  pla
  rts

lcd_wait:
  pha
  lda #%11110000 ; Port B D0-D3 are input
  sta DDRB
lcd_busy:
  lda #RW
  sta PORTB
  lda #(RW | E)
  sta PORTB
  lda PORTB
  asl
  asl
  asl
  asl
  sta lcd_addr
  lda #RW
  sta PORTB
  lda #(RW | E)
  sta PORTB
  lda PORTB
  and #%00001111
  ora lcd_addr
  sta lcd_addr
  and #%10000000
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
lcd_send_byte:
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
  stz PORTB      ; Set all pins on port B low
  ; lda #0
  ; sta PORTB      ; Set all pins on port B low
  pla
  rts

print_ps2_key:
  bit ps2_ignore_next_code
  bmi code_ignored

  cmp #$f0
  beq ignore_next

  cmp #$5f
  bpl too_high

  tax
  lda ps2_scan_codes,x
  jsr print_char
  rts
too_high:
  rts
ignore_next:
  lda #$FF
  sta ps2_ignore_next_code
  rts
code_ignored:
  stz ps2_ignore_next_code
  rts


wait_ms:
  sta tmp1
  phx
  phy
  ; txa
  ; pha
  ; tya
  ; pha
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
  ply
  plx
  ; pla
  ; tay
  ; pla
  ; tax
  lda tmp1
  rts


nmi:
  rti

irq:
  pha
  lda PORTA
  jsr print_ps2_key
  ; sta counter
  pla
  rti

  .align 8
ps2_scan_codes:
  ;     0123456789ABCDEF
  .asc "??????????????`?" ; 0
  .asc "?????Q1???ZSAW2?" ; 1
  .asc "?CXDE43?? VFTR5?" ; 2
  .asc "?NBHGY6???MJU78?" ; 3
  .asc "?,KIO09??./L;P-?" ; 4
  .asc "??'?[=?????]?\??" ; 5

  .org $fffa
  .word nmi
  .word reset
  .word irq
