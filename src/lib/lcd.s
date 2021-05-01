E  = %10000000
RW = %01000000
RS = %00100000

string_ptr = s0

lcd_init:
  pha
  lda #50
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_instruction.send_command
  lda #5
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_instruction.send_command
  lda #1
  jsr wait_ms
  lda #%00000011 ; Sets to 8-bit mode; 1-line display; 5x8 font
  jsr lcd_instruction.send_command
  lda #1
  jsr wait_ms
  lda #%00000010 ; Sets to 4-bit mode
  jsr lcd_instruction.send_command
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

lcd_instruction:
  jsr lcd_wait
.send_command:
  pha
  lsr            ; shift high nibble to low 4 bits
  lsr
  lsr
  lsr
  ora #E         ; Sets E bit
  sta VIA1_PORTB

  eor #E         ; Clear E bit
  sta VIA1_PORTB

  pla
  and #%00001111 ; Mask high nibble
  ora #E         ; Sets E bit
  sta VIA1_PORTB

  eor #E         ; Clear E bit
  sta VIA1_PORTB
  rts

lcd_wait:
  pha
  lda #%11110000 ; Port B D0-D3 are input
  sta VIA1_DDRB
.loop:
  lda #RW ; Set RW and pulse E to read LCD address
  sta VIA1_PORTB
  lda #(RW | E)
  sta VIA1_PORTB
  lda VIA1_PORTB ; Read high bits from LCD
  asl
  asl
  asl
  asl
  sta lcd_addr ; Shift bits into high bits of byte
  lda #RW ; Set RW and pulse E to read LCD address
  sta VIA1_PORTB
  lda #(RW | E)
  sta VIA1_PORTB
  lda VIA1_PORTB ; Read low bits from LCD
  and #%00001111 ; Mask off high bits which are not part of address
  ora lcd_addr ; Combine bits read with high bits and store complete address with busy flag
  sta lcd_addr
  and #%10000000 ; Check busy flag
  bne .loop

  lda #RW
  sta VIA1_PORTB
  lda #%11111111 ; Port B is output
  sta VIA1_DDRB
  pla
  rts


lcd_clear:
  lda #%00000001 ; Clear
  jsr lcd_instruction
  rts

print_char:
  pha
  jsr lcd_wait
  lsr            ; shift high nibble to low 4 bits
  lsr
  lsr
  lsr
  ora #RS        ; Set RS, clear RW/E bits
  sta VIA1_PORTB

  ora #E         ; Set E
  sta VIA1_PORTB

  eor #E         ; Clear E
  sta VIA1_PORTB

  pla
  and #%00001111 ; Mask high nibble
  ora #RS        ; Set RS, clear RW/E bits
  sta VIA1_PORTB

  ora #E         ; Set E
  sta VIA1_PORTB

  eor #E         ; Clear E
  sta VIA1_PORTB

  rts


print_message
  ldx #0
.loop:
  lda message,x
  beq .return
  jsr print_char
  inx
  jmp .loop
.return
  rts

; print null terminated string located at address contained in s0
; input s0
print
  ldy #0
.loop
  lda (string_ptr),y
  beq .return
  jsr print_char
  iny
  jmp loop
.return
  rts

