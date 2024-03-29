.segment "BIOS"
RELEASE   = %00000001
EXTENDED  = %00000010
CAPS_LOCK = %10000000

L_SHIFT     = %00000001
R_SHIFT     = %00000010
L_ALT       = %00000100
R_ALT       = %00001000
L_CTRL      = %00010000
R_CTRL      = %00100000
L_GUI       = %01000000
R_GUI       = %10000000

kb_init:
  stz KBflags
  stz KBmods
  rts

kb_handle:
  lda KBflags
  and #EXTENDED
  bne read_byte_extended

  lda KBflags
  and #RELEASE
  beq read_key

  lda KBflags
  eor #RELEASE
  sta KBflags
  lda Via1PRA
  cmp #$12
  beq l_shfit_up
  cmp #$59
  beq r_shfit_up
  jmp kb_handle_return

read_byte_extended
  lda KBflags
  eor #EXTENDED
  sta KBflags
  and #RELEASE
  beq read_key_extended
  lda KBflags
  eor #RELEASE
  sta KBflags
  lda Via1PRA
  jmp kb_handle_return

l_shfit_up:
  lda KBmods
  eor #L_SHIFT
  sta KBmods
  jmp kb_handle_return
r_shfit_up:
  lda KBmods
  eor #R_SHIFT
  sta KBmods
  jmp kb_handle_return

read_key:
  lda Via1PRA
  cmp #$F0
  beq key_released
  cmp #$E0
  beq extended
  cmp #$12
  beq l_shift_down
  cmp #$59
  beq r_shift_down
  cmp #$58
  beq caps_lock_down
  ; cmp #$76
  ; beq esc_down
  ; cmp #$66
  ; beq backspace_down
  ; cmp #$5A
  ; beq enter_down

  tax
  lda KBmods
  and #L_SHIFT
  bne shifted_key
  lda KBmods
  and #R_SHIFT
  bne shifted_key
  lda KBflags
  and #CAPS_LOCK
  bne caps_lock_key

  lda keymap,x
  jmp push_key

char_is_a_to_z
  sbc #$20
  jmp push_key 

shifted_key:
  lda keymap_shifted,x

push_key:
			    LDY ICNT	;get buffer counter (3)
					BMI	DISABLE_TRANSMIT	;check against limit, branch if full (2/3)
;
					LDY ITAIL ;room in buffer (3)
					STA IBUF,Y ;store into buffer (5)
					INC	ITAIL	;Increment tail pointer (5)
					RMB7	ITAIL	;Strip off bit 7, 128 bytes only (5)
					INC ICNT ;increment character count (5)
          jmp kb_handle_return
;	
DISABLE_TRANSMIT:
          LDA #%00001100 ;buffer overflow flag (2)
          STA STTVAL
          jmp kb_handle_return


key_released:
  lda KBflags
  ora #RELEASE
  sta KBflags
  jmp kb_handle_return

read_key_extended:
  lda Via1PRA
  cmp #$F0
  beq key_released
  cmp #$6B
  beq left_down
  cmp #$74
  beq right_down
  cmp #$71
  beq del_down
  jmp kb_handle_return

extended:
  lda KBflags
  ora #EXTENDED
  sta KBflags
  jmp kb_handle_return

l_shift_down:
  lda KBmods
  ora #L_SHIFT
  sta KBmods
  jmp kb_handle_return

r_shift_down:
  lda KBmods
  ora #R_SHIFT
  sta KBmods
  jmp kb_handle_return

caps_lock_down:
  lda KBflags
  eor #CAPS_LOCK
  sta KBflags
  jmp kb_handle_return
  
; esc_down:
;   jsr lcd_clear
;   jmp kb_handle_return

; backspace_down:
;   jsr lcd_cursor_left
;   lda #' '
;   jsr lcd_print_char
;   jsr lcd_cursor_left
;   jmp kb_handle_return

; enter_down:
;   lda #$0A
;   ldx in_wptr
;   sta in_buffer,x
;   inc in_wptr
;   lda #$0D
;   ldx in_wptr
;   sta in_buffer,x
;   inc in_wptr
;   jmp kb_handle_return

;   jsr lcd_new_line
;   jmp kb_handle_return

caps_lock_key:
  lda keymap,x
  tax
  clc
  adc #($FF - 'z')
  adc #('z' - 'a' + 1)
  txa
  bcs char_is_a_to_z
  jmp push_key

left_down:
  ; jsr lcd_screen_right
  jmp kb_handle_return

right_down:
  ; jsr lcd_screen_left
  jmp kb_handle_return

del_down:
  lda #$7F
  jmp push_key

kb_handle_return:
  rts

.align 256
keymap:
  ;      0123456789ABCDEF
  .byte "?????????????"
  .byte $09 ; 0D TAB
  .byte               "`?" ; 0
  .byte "?????q1???zsaw2?" ; 1
  .byte "?cxde43?? vftr5?" ; 2
  .byte "?nbhgy6???mju78?" ; 3
  .byte "?,kio09??./l;p-?" ; 4
  .byte "??'?[=????"       ; 5
  .byte $0D ; 5A ENT
  .byte            "]?\??" ; 5
  .byte "??????"
  .byte $08 ; 66 BS
  .byte        "??1?47???" ; 6
  .byte "0.2568"
  .byte $1B ; 76 ESC
  .byte        "??+3-*9??" ; 7
  .byte "????????????????" ; 8
  .byte "????????????????" ; 9
  .byte "????????????????" ; A
  .byte "????????????????" ; B
  .byte "????????????????" ; C
  .byte "????????????????" ; D
  .byte "????????????????" ; E
  .byte "????????????????" ; F
keymap_shifted:
  ;      0123456789ABCDEF
  .byte "?????????????"
  .byte $09 ; 0D TAB
  .byte               "~?" ; 0
  .byte "?????Q!???ZSAW@?" ; 1
  .byte "?CXDE$#?? VFTR%?" ; 2
  .byte "?NBHGY^???MJU&*?" ; 3
  .byte "?<KIO)(??>?L:P_?" ; 4
  .byte "??"               ; 5
  .byte   '"'              ; 5
  .byte    "?{+????"       ; 5
  .byte $0D ; 5A ENT
  .byte            "}?|??" ; 5
  .byte "??????"
  .byte $08 ; 66 BS
  .byte        "??1?47???" ; 6
  .byte "0.2568"
  .byte $1B ; 76 ESC
  .byte        "??+3-*9??" ; 7
  .byte "????????????????" ; 8
  .byte "????????????????" ; 9
  .byte "????????????????" ; A
  .byte "????????????????" ; B
  .byte "????????????????" ; C
  .byte "????????????????" ; D
  .byte "????????????????" ; E
  .byte "????????????????" ; F
