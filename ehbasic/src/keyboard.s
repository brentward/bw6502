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

.segment "BIOS"
kb_init:
  stz kb_flags
  stz kb_modifiers
  rts

kb_handle:
  phx

  lda kb_flags
  and #EXTENDED
  bne read_byte_extended

  lda kb_flags
  and #RELEASE
  beq read_key
  lda kb_flags
  eor #RELEASE
  sta kb_flags
  lda VIA1_PORTA
  cmp #$12
  beq l_shfit_up
  cmp #$59
  beq r_shfit_up
  cmp #$14
  beq l_ctrl_up
  jmp kb_handle_return

read_byte_extended:
  lda VIA1_PORTA
  cmp #$F0
  bne not_extended_key_release
  jmp key_released
not_extended_key_release:
  lda kb_flags
  eor #EXTENDED
  sta kb_flags
  and #RELEASE
  bne not_key_extended
  jmp read_key_extended
not_key_extended:
  lda kb_flags
  eor #RELEASE
  sta kb_flags
  lda VIA1_PORTA
  cmp #$14
  beq r_ctrl_up
  jmp kb_handle_return

l_shfit_up:
  lda kb_modifiers
  eor #L_SHIFT
  sta kb_modifiers
  jmp kb_handle_return
r_shfit_up:
  lda kb_modifiers
  eor #R_SHIFT
  sta kb_modifiers
  jmp kb_handle_return
l_ctrl_up:
  lda kb_modifiers
  eor #L_CTRL
  sta kb_modifiers
  jmp kb_handle_return
r_ctrl_up:
  lda kb_modifiers
  eor #R_CTRL
  sta kb_modifiers
  jmp kb_handle_return


read_key:
  lda VIA1_PORTA
  cmp #$F0
  bne not_key_released
  jmp key_released
not_key_released:
  cmp #$E0
  bne not_extended
  jmp extended
not_extended
  cmp #$83 ;F7 is the only key above $7F so we can cut keymaps in half if we ignore this
  bne not_f7
  jmp kb_handle_return
not_f7:
  cmp #$12
  bne not_l_shift_down
  jmp l_shift_down
not_l_shift_down:
  cmp #$59
  bne not_r_shift_down
  jmp r_shift_down
not_r_shift_down:
  cmp #$58
  bne not_caps_lock_down
  jmp caps_lock_down
not_caps_lock_down:
  cmp #$14
  bne not_l_ctrl_down
  jmp l_ctrl_down
not_l_ctrl_down:

  ; cmp #$76
  ; beq esc_down
  ; cmp #$66
  ; beq backspace_down
  ; cmp #$5A
  ; beq enter_down

  tax
  lda kb_modifiers
  and #L_SHIFT
  bne shifted_key
  lda kb_modifiers
  and #R_SHIFT
  bne shifted_key
  lda kb_modifiers
  and #L_CTRL
  bne ctrl_key
  lda kb_modifiers
  and #R_CTRL
  bne ctrl_key
  lda kb_flags
  and #CAPS_LOCK
  beq normal_key 
  jmp caps_lock_key
normal_key:
  lda keymap,x
  jmp push_key

char_is_a_to_z
  sbc #$20
  jmp push_key 

shifted_key:
  lda keymap_shifted,x
  jmp push_key

ctrl_key:
  ; lda keymap_ctrl,x

;   lda keymap_shifted,x
;   sbc #$40
;   bne ignore_ctrl_key
;   jmp push_key
; ignore_ctrl_key
;   jmp kb_handle_return
  lda keymap_shifted,x
  tax
  clc
  adc #($FF - '_')
  adc #('_' - '@' + 1)
  txa
  bcc check_exta_ctrl
  sbc #$40
  jmp push_key
check_exta_ctrl:
  tax
  clc
  adc #($FF - '}')
  adc #('}' - '[' + 1)
  txa
  bcc ignore_ctrl_key
  sbc #$60
  jmp push_key
ignore_ctrl_key:
  jmp kb_handle_return


push_key:
  ; ldx in_wptr
  ; sta in_buffer,x
  ; inc in_wptr
  pha
  jsr buf_dif
  cmp		#$80        	; If it has less than 128 bytes unread,
	bcc		@push			; write to buffer.
	lda		#$07			; Ring bell
	jsr		buf_write
  pla
  jmp kb_handle_return
@push:
  pla
  jsr buf_write
  jmp kb_handle_return

key_released:
  lda kb_flags
  ora #RELEASE
  sta kb_flags
  jmp kb_handle_return

read_key_extended:
  lda VIA1_PORTA
  cmp #$6B
  beq left_down
  cmp #$74
  beq right_down
  cmp #$71
  beq del_down
  cmp #$14
  beq r_ctrl_down
  jmp kb_handle_return

extended:
  lda kb_flags
  ora #EXTENDED
  sta kb_flags
  jmp kb_handle_return

l_shift_down:
  lda kb_modifiers
  ora #L_SHIFT
  sta kb_modifiers
  jmp kb_handle_return

r_shift_down:
  lda kb_modifiers
  ora #R_SHIFT
  sta kb_modifiers
  jmp kb_handle_return

caps_lock_down:
  lda kb_flags
  eor #CAPS_LOCK
  sta kb_flags
  jmp kb_handle_return
  
l_ctrl_down:
  lda kb_modifiers
  ora #L_CTRL
  sta kb_modifiers
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
  bcc push_key
  jmp char_is_a_to_z
  ; jmp push_key

left_down:
  jsr lcd_screen_right
  jmp kb_handle_return

right_down:
  jsr lcd_screen_left
  jmp kb_handle_return

del_down:
  lda #$7F
  jmp push_key
  jmp kb_handle_return


r_ctrl_down:
  lda kb_modifiers
  ora #R_CTRL
  sta kb_modifiers

kb_handle_return:
  plx
  rts

.align 128
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
  ; .byte "????????????????" ; 8
  ; .byte "????????????????" ; 9
  ; .byte "????????????????" ; A
  ; .byte "????????????????" ; B
  ; .byte "????????????????" ; C
  ; .byte "????????????????" ; D
  ; .byte "????????????????" ; E
  ; .byte "????????????????" ; F
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
  ; .byte "????????????????" ; 8
  ; .byte "????????????????" ; 9
  ; .byte "????????????????" ; A
  ; .byte "????????????????" ; B
  ; .byte "????????????????" ; C
  ; .byte "????????????????" ; D
  ; .byte "????????????????" ; E
  ; .byte "????????????????" ; F
; keymap_ctrl:
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; 0
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$3F,$3F,$3F,$3F,$11,$3F,$3F,$3F,$3F,$1A,$13,$01,$17,$00,$3F ; 1
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$03,$18,$04,$05,$3F,$3F,$3F,$3F,$3F,$16,$06,$14,$12,$3F,$3F ; 2
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$0E,$02,$08,$07,$19,$1E,$3F,$3F,$3F,$0D,$0A,$15,$3F,$3F,$3F ; 3
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$3F,$0B,$09,$0F,$3F,$3F,$3F,$3F,$3F,$3F,$0C,$3F,$10,$1F,$3F ; 4
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$3F,$3F,$3F,$1B,$3F,$3F,$3F,$3F,$3F,$3F,$1D,$3F,$1C,$3F,$3F ; 5
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; 6
;         ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
;   .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; 7
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; 8
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; 9
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; A
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; B
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; C
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; D
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; E
  ;       ; 0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F
  ; .byte $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ; F
