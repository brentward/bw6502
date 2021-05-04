SET_DDRAM_ADDR       = %10000000

SET_CGRAM_ADDR       = %01000000

FUNCTION_SET         = %00100000
FUNCTION_8_BIT       = %00010000
FUNCTION_2_LINE      = %00001000
FUNCTION_5x10_FONT   = %00000100

CD_SHIFT             = %00010000
CD_SHIFT_DISPLAY     = %00001000
CD_SHIFT_RIGHT       = %00000100


DISPLAY_CONTROL      = %00001000
DISPLAY_ON           = %00000100
DISPLAY_CURSOR_ON    = %00000010
DISPLAY_CURSOR_BLINK = %00000001

ENTRY_MODE_SET       = %00000100
ENTRY_MODE_INCREMENT = %00000010
ENTRY_MODE_SHIFT     = %00000001

RETURN_HOME          = %00000010

CLEAR_DISPLAY        = %00000001


E  = %10000000
RW = %01000000
RS = %00100000

string_ptr = r0

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
  lda #(FUNCTION_SET | FUNCTION_2_LINE) ; Sets to 4-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #(ENTRY_MODE_SET | ENTRY_MODE_INCREMENT) ; Entry mode set; increment and shift cursor; no scroll 
  jsr lcd_instruction
  lda #CLEAR_DISPLAY ; Clear display
  jsr lcd_instruction
  lda #(DISPLAY_CONTROL | DISPLAY_ON | DISPLAY_CURSOR_ON) ; Display on; cursor on; blink off 
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
  lda #CLEAR_DISPLAY ; Clear
  jsr lcd_instruction

lcd_home:
  lda #RETURN_HOME
  jsr lcd_instruction
  rts

lcd_cursor_left:
  lda #CD_SHIFT
  jsr lcd_instruction
  rts

lcd_cursor_right:
  lda #(CD_SHIFT | CD_SHIFT_RIGHT)
  jsr lcd_instruction
  rts

lcd_screen_left:
  lda #(CD_SHIFT | CD_SHIFT_DISPLAY)
  jsr lcd_instruction
  rts

lcd_screen_right:
  lda #(CD_SHIFT | CD_SHIFT_DISPLAY | CD_SHIFT_RIGHT)
  jsr lcd_instruction
  rts

lcd_set_ddram_addr: ; Sets cursor position to value in A register
  ora #SET_DDRAM_ADDR
  jsr lcd_instruction
  rts

lcd_print_char:
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


lcd_print_screen_buf
  ldx #0
.loop:
  lda screen_buf,x
  beq .return
  jsr lcd_print_char
  inx
  jmp .loop
.return
  rts

; print null terminated string located at address contained in s0
; input r0
lcd_print
  ldy #0
.loop
  lda (string_ptr),y
  beq .return
  jsr lcd_print_char
  iny
  jmp loop
.return
  rts

push_char_screen_buf:
  pha
  ldx #0

.char_loop
  lda screen_buf,x
  beq .add_char
  inx
  jmp .char_loop

.add_char
  pla
  sta screen_buf,x
  inx
  stz screen_buf,x
  rts

