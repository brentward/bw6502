
; Minimal monitor for my 6502 Single Board Computer.
.setcpu "65C02"
.code
	
	.include "basic.s"
	.include "acia.s"
	.include "via.s"
	.include "lcd.s"
	.include "utils.s"
	.include "keyboard.s"

; ; Defines
; r0 = $E2 ; 2 bytes
; r0L = $E2 ; low byte
; r0H = $E3 ; high byte
; r1 = $E4 ; 2 bytes
; r1L = $E4 ; low byte
; r1H = $E5 ; high byte
; r2 = $E6 ; 2 bytes
; r2L = $E6 ; low byte
; r2H = $E7 ; high byte
; r3 = $E8 ; 2 bytes
; r3L = $E8 ; low byte
; r3H = $E9 ; high byte
; lcd_addr = $EA ; 1 byte, lcd busy flag and address
; kb_wptr = $EB ; 1 byte
; kb_rptr = $EC ; 1 byte
; kb_flags = $ED ; 1 byte
; kb_modifiers = $EE ; 1 byte
; ACIA := $0220
; ACIAData := ACIA+0
; ACIAStatus := ACIA+1
; ACIAReset := ACIA+1
; ACIACommand := ACIA+2
; ACIAControl := ACIA+3
kb_buffer = $0400 ; 256 bytes 0x0400-0x04ff

; Put the IRQ and NMI code in RAM so that it can be changed

IRQ_vec	= VEC_SV+2	; IRQ code vector
NMI_vec	= IRQ_vec+$0A	; NMI code vector

; Now the code. all this does is set up the vectors and interrupt code
; and wait for the user to select [C]old or [W]arm start. Nothing else.
; Fits in less than 128 bytes

; Reset vector points here

RES_vec
	CLD				; clear decimal mode
	LDX	#$FF			; empty stack
	TXS				; set the stack

	jsr via_init
	jsr lcd_init
	jsr acia_init
	jsr kb_init
	cli

	ldx #0
PrintWelcome
	lda WELCOME_mess,x
	beq print_next
	jsr lcd_print_char
	inx
	jmp PrintWelcome
print_next
	jsr lcd_new_line
	ldx #0
PrintBASIC
	lda BASIC_mess,x
	beq PrintDone
	jsr lcd_print_char
	inx
	jmp PrintBASIC
PrintDone

    ; STZ ACIAReset

	; LDA #$10		; Set ACIA baud rate, word size and Rx interrupt (to control RTS)
	; STA	ACIAControl

    ; LDA #$0B
    ; STA ACIACommand

; Set up vectors and interrupt code, copy them to page 2.

	LDY	#END_CODE-LAB_vec	; set index/count
LAB_stlp
	LDA	LAB_vec-1,Y		; get byte from interrupt code
	STA	VEC_IN-1,Y		; save to RAM
	DEY				; decrement index/count
	BNE	LAB_stlp		; loop if more to do

; Now do the signon message, Y = $00 here

LAB_signon
	LDA	LAB_mess,Y		; get byte from sign on message
	BEQ	LAB_nokey		; exit loop if done

	JSR	V_OUTP		        ; output character
	INY				; increment index
	BNE	LAB_signon		; loop, branch always

LAB_nokey
	JSR	V_INPT                  ; call scan input device
	BCC	LAB_nokey		; loop if no key

	AND	#$DF			; mask xx0x xxxx, ensure upper case

	CMP	#'W'			; compare with [W]arm start
	BEQ	LAB_dowarm		; branch if [W]arm start

	CMP	#'C'			; compare with [C]old start
	BNE	RES_vec		        ; loop if not [C]old start

	JMP	LAB_COLD		; do EhBASIC cold start

LAB_dowarm
	JMP	LAB_WARM		; do EhBASIC warm start

; Byte out to serial console

SCRNout
	jsr acia_write
	rts

; Byte in from serial console

KBDin
	; jsr acia_check
	; rts
	sei
	lda kb_rptr
	cmp kb_wptr
	cli
	beq NoDataIn
	ldx kb_rptr
	lda kb_buffer,x
	inc kb_rptr
	sec
	rts
NoDataIn:
	jsr acia_check
	; CLC		                ; Carry clear if no key pressed
	RTS


; LOAD - currently does nothing.
SBCload				        ; load vector for EhBASIC
	RTS

; SAVE - currently does nothing.
SBCsave				        ; save vector for EhBASIC
	RTS

; vector tables

LAB_vec
	.word	KBDin                   ; byte in from keyboard
	.word	SCRNout		        ; byte out to screen
	.word	SBCload		        ; load vector for EhBASIC
	.word	SBCsave		        ; save vector for EhBASIC

; EhBASIC IRQ support

IRQ_CODE
	PHA				; save A
	jsr kb_handle
	LDA	IrqBase		        ; get the IRQ flag byte
	LSR				; shift the set b7 to b6, and on down ...
	ORA	IrqBase		        ; OR the original back in
	STA	IrqBase		        ; save the new IRQ flag byte
	PLA				; restore A
	RTI

; EhBASIC NMI support

NMI_CODE
	PHA				; save A
	LDA	NmiBase		        ; get the NMI flag byte
	LSR				; shift the set b7 to b6, and on down ...
	ORA	NmiBase		        ; OR the original back in
	STA	NmiBase		        ; save the new NMI flag byte
	PLA				; restore A
	RTI

END_CODE

LAB_mess
	.byte	$0D,$0A,"6502 EhBASIC",$0D,$0A, "[C]old/[W]arm?",$00
					; sign on string

WELCOME_mess
	.byte	" Welcome:  6502 ",$00
					; Welcome string

BASIC_mess
	.byte	" EhBASIC  v2.22 ",$00
					; EhBASIC v string

; system vectors

        ; .res    $FFFA-*
.segment "VECTORS"
	.word	NMI_vec		; NMI vector
	.word	RES_vec		; RESET vector
	.word	IRQ_vec		; IRQ vector
