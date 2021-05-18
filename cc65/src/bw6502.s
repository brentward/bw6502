
; Minimal monitor for my 6502 Single Board COmputer.
.setcpu "65C02"
	.include "ehbasic.s"
	.include "acia.s"
	.include "decimal.s"
	.include "keyboard.s"
	.include "lcd.s"
	.include "utils.s"
	.include "via.s"
	; .include "zeropage.s"

; System Variables pages 03-0A
kb_buffer		= $0300	; 256 bytes 0x0300-0x03ff
screen_buf		= $0400	; 256 bytes 0x0400-0x04ff
decimal_string	= $0500	; 6 bytes 0x0500-0x0505
;				= $0506 ; unused
; ...
;				= $0AFF ; unused


; Put the IRQ and NMI code in RAM so that it can be changed

IRQ_vec	= VEC_SV+2	; IRQ code vector
NMI_vec	= IRQ_vec+$0A	; NMI code vector

; Now the code. all this does is set up the vectors and interrupt code
; and wait for the user to select [C]old or [W]arm start. Nothing else.
; Fits in less than 128 bytes

; Reset vector points here

RES_vec
	CLD				; clear decimal mode
	LDX	#$FF		; empty stack
	TXS				; set the stack
	jsr via_init
	jsr lcd_init
	jsr kb_init
	jsr acia_init

	LDX #0
LCD_Welcome_loop
	LDA Welcome_mess,x
	BEQ LCD_EhBASIC
	JSR lcd_print_char
	INX
	JMP LCD_Welcome_loop

LCD_EhBASIC
	jsr lcd_new_line
	LDX #0
LCD_EhBASIC_loop
	LDA EhBASIC_mess,x
	BEQ LCD_Message_done
	JSR lcd_print_char
	INX
LCD_Message_done



; Set up vectors and interrupt code, copy them to page 2.

	LDY	#END_CODE-LAB_vec	; set index/count
LAB_stlp
	LDA	LAB_vec-1,Y		; get byte from interrupt code
	STA	VEC_IN-1,Y		; save to RAM
	DEY					; decrement index/count
	BNE	LAB_stlp		; loop if more to do

; Now do the signon message, Y = $00 here

LAB_signon
	LDA	LAB_mess,Y		; get byte from sign on message
	BEQ	LAB_nokey		; exit loop if done

	JSR	V_OUTP			; output character
	INY					; increment index
	BNE	LAB_signon		; loop, branch always

LAB_nokey
	JSR	V_INPT			; call scan input device
	BCC	LAB_nokey		; loop if no key

	AND	#$DF			; mask xx0x xxxx, ensure upper case

	CMP	#'W'			; compare with [W]arm start
	BEQ	LAB_dowarm		; branch if [W]arm start

	CMP	#'C'			; compare with [C]old start
	BNE	RES_vec			; loop if not [C]old start

	JMP	LAB_COLD		; do EhBASIC cold start

LAB_dowarm
	JMP	LAB_WARM		; do EhBASIC warm start

; Byte out to serial console

SCRNout
	JSR acia_write
	RTS

; Byte in from serial console

KBDin
	sei
	lda kb_rptr
	cmp kb_wptr
	cli
	bne new_kb_char
	jmp acia_check
new_kb_char:
	phx
	ldx kb_rptr
	lda kb_buffer,X
	sec
	plx
	rts

; SerialIn
; 	LDA	ACIAStatus
; 	AND	#%00001000
; 	BEQ	NoDataIn
; 	LDA	ACIAData
; 	SEC					; Carry set if key available
; 	RTS
; NoDataIn
; 	CLC					; Carry clear if no key pressed
; 	RTS

; LOAD - currently does nothing.
SBCload					; load vector for EhBASIC
	RTS

; SAVE - currently does nothing.
SBCsave					; save vector for EhBASIC
	RTS

; vector tables

LAB_vec
	.word	KBDin				; byte in from keyboard
	.word	SCRNout		        ; byte out to screen
	.word	SBCload		        ; load vector for EhBASIC
	.word	SBCsave		        ; save vector for EhBASIC

; EhBASIC IRQ support

IRQ_CODE
	PHA				; save A
	LDA	IrqBase		; get the IRQ flag byte
	LSR				; shift the set b7 to b6, and on down ...
	ORA	IrqBase		; OR the original back in
	STA	IrqBase		; save the new IRQ flag byte
	JSR	kb_handle
	PLA				; restore A
	RTI

; EhBASIC NMI support

NMI_CODE
	PHA				; save A
	LDA	NmiBase		; get the NMI flag byte
	LSR				; shift the set b7 to b6, and on down ...
	ORA	NmiBase		; OR the original back in
	STA	NmiBase		; save the new NMI flag byte
	PLA				; restore A
	RTI

END_CODE

LAB_mess
	.byte	$0D,$0A,"6502 EhBASIC",$0D,$0A, "[C]old/[W]arm?",$00
					; sign on string

Welcome_mess
	.byte	"Welcome!",$00

EhBASIC_mess
	.byte	"6502 EhBASIC",$00

; system vectors

        .res    $FFFA-*

	.word	NMI_vec		; NMI vector
	.word	RES_vec		; RESET vector
	.word	IRQ_vec		; IRQ vector
