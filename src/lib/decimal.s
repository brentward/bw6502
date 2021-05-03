value = r0 ; 2 bytes
mod10 = r1 ; 2 bytes
  ; converts 16 bit value decimal as ascii
  ; input: s0
  ; output: decimal_string
  ; uses s0, s1,
convert_to_decimal
  lda #0
  sta decimal_string

.divide:
  ; Init the remainder to 0
  lda #0
  sta mod10
  sta mod10 + 1
  clc

  ldx #16
.loop:
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
  bcc .ignore_result ; branch if divident < divisor
  sty mod10
  sta mod10 + 1

.ignore_result:
  dex
  bne .loop
  rol value ; shift in the last bit of the quotient
  rol value + 1

  lda mod10
  clc
  adc #"0"
  jsr push_decimal_char

  ; if value != 0 then continue dividing
  lda value
  ora value + 1
  bne .divide ; branch if value not 0

; Add the character in the a register to the beginning of the
; null-terminated string `message`
push_decimal_char:
  pha ; Push new first char onto stack
  ldy #0

.loop:
  lda decimal_string,y ; Get char on string an put into x
  tax
  pla
  sta decimal_string,y ; Pull char off stack and add it to the string
  iny
  txa
  pha           ; Push char from string onto stack
  bne .loop
  
  pla 
  sta decimal_string,y ; Pull the null off the stack and add to the end of the string

  rts

