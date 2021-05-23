
; Minimal monitor for my 6502 Single Board Computer.
.setcpu "65C02"
	.include "zeropage.s"

.segment "BIOS"

	.include "basic22p5.s"
	.include "acia.s"
	.include "via.s"
	.include "lcd.s"
	.include "utils.s"
	.include "keyboard.s"
	.include "io.s"

.segment "BIOS"

; ; Defines
; lcd_addr		= $E2	; 1 byte, lcd busy flag and address
; in_wptr			= $E3	; 1 byte
; in_rptr			= $E4	; 1 byte
; kb_flags		= $E5	; 1 byte
; kb_modifiers 	= $E6	; 1 byte
; r0				= $E8	; 2 bytes
; r0L				= $E8	; low byte
; r0H				= $E9	; high byte
; r1				= $EA	; 2 bytes
; r1L				= $EA	; low byte
; r1H				= $EB	; high byte
; r2				= $EC	; 2 bytes
; r2L				= $EC	; low byte
; r2H				= $ED	; high byte

; Put the IRQ and NMI code in RAM so that it can be changed

; IRQ_vec	= VEC_SV+2	; IRQ code vector
; NMI_vec	= IRQ_vec+$0A	; NMI code vector

; Now the code. all this does is set up the vectors and interrupt code
; and wait for the user to select [C]old or [W]arm start. Nothing else.
; Fits in less than 128 bytes

; Reset vector points here
EXIT:
RES_vec
	cld				; clear decimal mode
	ldx		#$FF	; empty stack
	txs				; set the stack

	jsr		via_init
	jsr		lcd_init
	jsr		acia_init
	jsr		io_init
	jsr		kb_init
	cli

	ldx		#0
PrintWelcome
	lda		WELCOME_mess,x
	beq		print_next
	jsr		lcd_print_char
	inx
	jmp		PrintWelcome
print_next
	jsr		lcd_new_line
	ldx		#0
PrintBASIC
	lda		BASIC_mess,x
	beq		PrintDone
	jsr		lcd_print_char
	inx
	jmp		PrintBASIC
PrintDone

	jmp		ROM_START

; ; Set up vectors and interrupt code, copy them to page 2.

; 	LDY	#END_CODE-LAB_vec	; set index/count
; LAB_stlp
; 	LDA	LAB_vec-1,Y		; get byte from interrupt code
; 	STA	VEC_IN-1,Y		; save to RAM
; 	DEY				; decrement index/count
; 	BNE	LAB_stlp		; loop if more to do

; ; Now do the signon message, Y = $00 here

; LAB_signon
; 	LDA	LAB_mess,Y		; get byte from sign on message
; 	BEQ	LAB_nokey		; exit loop if done

; 	JSR	V_OUTP		        ; output character
; 	INY				; increment index
; 	BNE	LAB_signon		; loop, branch always

; LAB_nokey
; 	JSR	V_INPT                  ; call scan input device
; 	BCC	LAB_nokey		; loop if no key

; 	AND	#$DF			; mask xx0x xxxx, ensure upper case

; 	CMP	#'W'			; compare with [W]arm start
; 	BEQ	LAB_dowarm		; branch if [W]arm start

; 	CMP	#'C'			; compare with [C]old start
; 	BNE	RES_vec		        ; loop if not [C]old start

; 	JMP	LAB_COLD		; do EhBASIC cold start

; LAB_dowarm
; 	JMP	LAB_WARM		; do EhBASIC warm start

; Byte out to serial console

CHROUT
	jsr acia_write
	rts

; Byte in from serial console or keyboard

CHRIN_NW
	; jsr acia_read
	; rts
	; lda in_cnt
	jsr buf_dif
	; jsr buf_read
	; cmp #$60				; if it is over 96
	cmp #$E0        		; Is it at least 224?
	bcs buf_full			; leave the sending end turned off
	jsr acia_resume_rx
buf_full:
	jsr buf_read
	rts


; 	jsr buf_dif				; get bytes to read
; 	beq NoDataIn			; If 0 branch to NoDataIn
; 	ldx in_rptr				; load the read pointer into X
; 	lda in_buffer,x			; and read the byte from the buffer
; 	pha						; them save it to the stack
; 	inc in_rptr				; increment the read pointer
; 	jsr buf_dif				; get bytes to read still
; 	cmp #$E0				; if it is over 224
; 	bcs buf_full			; leave the sending end turned off
; 	jsr acia_resume_rx		; otherwise set RTSB low to request RX
; buf_full:
; 	pla						; pull the byte from the stack
; 	sec						; Set carry if byte received
; 	rts
; NoDataIn:
; 	clc		                ; Carry clear no byte received pressed
; 	rts


; LOAD - currently does nothing.
LOAD				        ; load vector for EhBASIC
	RTS

; SAVE - currently does nothing.
SAVE				        ; save vector for EhBASIC
	RTS

; vector tables

; LAB_vec
; 	.word	KBDin                   ; byte in from keyboard
; 	.word	SCRNout		        ; byte out to screen
; 	.word	SBCload		        ; load vector for EhBASIC
; 	.word	SBCsave		        ; save vector for EhBASIC

; EhBASIC IRQ support

IRQ
	pha				; save A
    lda		ACIA_STATUS             ; Check if ACIA wants service   
    bpl		no_acia_int                ; bit 7 not set, so no
    jsr		acia_handle          ; service ACIA
no_acia_int
	lda		VIA1_IFR
	bpl		no_via1_int
	jsr		kb_handle
no_via1_int
	PLA				; restore A
	RTI
irq_handle:
		
; IRQ_VECTOR   ;This is the ROM start for the BRK/IRQ handler
; 		PHA   ;Save A Reg (3)
; 		PHX   ;Save X Reg (3)
; 		PHY   ;Save Y Reg (3)
; 		TSX   ;Get Stack pointer (2)
; 		LDA   $0100+4,X   ;Get Status Register (4)
; 		AND   #$10   ;Mask for BRK bit set (2)
; 		BEQ   DO_IRQ   ;If not set, handle IRQ (2/3)
; 		JMP   (BRKVEC)   ;Jump to Soft vectored BRK Handler (5) (24 clock cycles to vector routine)
; DO_IRQ
; 		JMP   (IRQVEC)   ;Jump to Soft vectored IRQ Handler (5) (25 clock cycles to vector routine)
; ;
; IRQ_EXIT      ;This is the standard return for the IRQ/BRK handler routines
; 		PLY   ;Restore Y Reg (4)
; 		PLX   ;Restore X Reg (4)
; 		PLA   ;Restore A Reg (4)
; 		RTI   ;Return from IRQ/BRK routine (6) (18 clock cycles from vector jump to IRQ end)

; EhBASIC NMI support

NMI
		RTI

; END_CODE

; LAB_mess
; 	.byte	$0D,$0A,"6502 EhBASIC",$0D,$0A, "[C]old/[W]arm?",$00
; 					; sign on string

WELCOME_mess
	.byte	" Welcome:  6502 ",$00
					; Welcome string

BASIC_mess
	.byte	" EhBASIC  v2.22 ",$00
					; EhBASIC v string

; system vectors

        ; .res    $FFFA-*
.segment "VECTORS"
	.word	NMI		; NMI vector
	.word	RES_vec		; RESET vector
	.word	IRQ		; IRQ vector
