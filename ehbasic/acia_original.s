; ACIA Ports
ACIA_BASE			= $0220
ACIA_DATA			= ACIA_BASE + $0
ACIA_STATUS			= ACIA_BASE + $1
ACIA_RESET			= ACIA_BASE + $1
ACIA_COMMAND		= ACIA_BASE + $2
ACIA_CONTROL		= ACIA_BASE + $3

; ACIA Status Register
ACIA_INT_ENABLE		= %10000000
ACIA_DSR_NOT_READY	= %01000000
ACIA_DCD_NOT_DETECD	= %00100000
ACIA_TX_DR_EMPTY	= %00010000
ACIA_RX_DR_FULL		= %00001000
ACIA_OVERFLOW_ERROR	= %00000100
ACIA_FRAMING_ERROR	= %00000010
ACIA_PARITY_ERROR	= %00000001

; ACIA Control Register
; Stop Bit Number (SBN) bit 7
ACIA_1_SBN			= %00000000
ACIA_2_SBN			= %10000000
; Word Length (WL) bits 6-5
ACIA_WL_8			= %00000000
ACIA_WL_7			= %00100000
ACIA_WL_6			= %01000000
ACIA_WL_5			= %01100000
; Receiver Clock Source (RCS) bit 4
ACIA_RX_CLK_EXT		= %00000000
ACIA_RX_CLK_B_RATE	= %00010000
; Selected Baud Rate (SBR) bits 3-0
ACIA_BAUD_115200	= %00000000
ACIA_BAUD_50		= %00000001
ACIA_BAUD_75		= %00000010
ACIA_BAUD_109_92	= %00000011
ACIA_BAUD_134_58	= %00000100
ACIA_BAUD_150		= %00000101
ACIA_BAUD_300		= %00000110
ACIA_BAUD_600		= %00000111
ACIA_BAUD_1200		= %00001000
ACIA_BAUD_1800		= %00001001
ACIA_BAUD_2400		= %00001010
ACIA_BAUD_3600		= %00001011
ACIA_BAUD_4800		= %00001100
ACIA_BAUD_7200		= %00001101
ACIA_BAUD_9600		= %00001110
ACIA_BAUD_19200		= %00001111

; ACIA Command Register
ACIA_NO_PARITY		= %00000000
ACIA_NO_ECHO		= %00000000
ACIA_ECHO_MODE		= %00010000
; Transmitter Interrupt Control (TIC)
ACIA_RTSB_H			= %00000000
ACIA_RTSB_L			= %00001000
ACIA_RTSB_L_TX_BRK	= %00001100
; Receiver Interrupt Request Disabled (IRD)
ACIA_RX_IRQ			= %00000000
ACIA_RX_NO_IRQ		= %00000010
; Data Terminal Ready (DTR)
ACIA_DTR			= %00000001

acia_init:
	pha
	stz		ACIA_RESET
	lda		#(ACIA_1_SBN | ACIA_WL_8 | ACIA_RX_CLK_B_RATE | ACIA_BAUD_115200)
	sta		ACIA_CONTROL

	lda		#(ACIA_NO_PARITY | ACIA_NO_ECHO | ACIA_RTSB_L | ACIA_RX_NO_IRQ | ACIA_DTR)
	; lda		#(ACIA_NO_PARITY | ACIA_NO_ECHO | ACIA_RTSB_L | ACIA_RX_IRQ | ACIA_DTR)
	sta		ACIA_COMMAND
	pla
	rts
 ;-------------

acia_resume_rx:
	lda		#(ACIA_NO_PARITY | ACIA_NO_ECHO | ACIA_RTSB_L | ACIA_RX_IRQ | ACIA_DTR)
	sta		ACIA_COMMAND
	rts
 ;-------------

acia_write:
	sta 	ACIA_DATA
	jsr 	delay_6551
	rts
 ;-------------

acia_get_byte:
	lda 	ACIA_STATUS			; Load the ACIA Status
	and 	#ACIA_RX_DR_FULL	; Checks if RX Data Register is full
	beq 	acia_get_byte		; Loop if no new data
	lda 	ACIA_DATA			; Load received data into A register
	rts
 ;-------------

acia_read:
	lda		ACIA_STATUS			; Load the ACIA Status
	and		#ACIA_RX_DR_FULL	; Checks if RX Data Register is full
	beq		@no_data
	lda		ACIA_DATA			; Load received data into A register
	sec							; Carry set if data available
	rts
@no_data:
	clc							; Carry clear if no key pressed
	rts
 ;-------------

; acia_handle:
; 	phx
; 	lda		ACIA_STATUS		; Get the contents of the ACIA's status register.
; 	; BPL		@end		; If ACIA didn't call, just exit.
; 	and		#(ACIA_OVERFLOW_ERROR | ACIA_FRAMING_ERROR | ACIA_PARITY_ERROR)	; Check for error conditions by ANDing with 7.
; 	bne		@report_err		; If there was any error condx, go report it.

; 	lda		ACIA_DATA		; Get the data from the ACIA
; 	jsr		buf_write		; and store it in the buffer.

; 	jsr		buf_dif			; Now see how full the buffer is.
; 	cmp		#$F0			; If it has less than 240 bytes unread,
; 	bcc		@end			; just exit the ISR here.

; 	lda		#(ACIA_NO_PARITY | ACIA_NO_ECHO | ACIA_RTSB_H | ACIA_RX_IRQ | ACIA_DTR)	; Else, tell the other end to stop sending data before
; 	sta		ACIA_COMMAND	; the buffer overflows, by storing 1 in the ACIA's
; 							; command register.	(See text.)
; 	jmp		@end
; @report_err:
; 	lda		#$07			; Ring bell
; 	jsr		buf_write

;  @end:
;  	plx						; Restore X , and return from interrupt.
; 	rts
;  ;-------------




; Latest WDC 65C51 has a bug - Xmit bit in status register is stuck on
; IRQ driven transmit is not possible as a result - interrupts are endlessly triggered
; Polled I/O mode also doesn't work as the Xmit bit is polled - delay routine is the only option
; The following delay routine kills time to allow W65C51 to complete a character transmit
; 0.523 milliseconds required loop time for 19,200 baud rate
; .mini_delay routine takes 524 clock cycles to complete - X Reg is used for the count loop
; Y Reg is loaded with the CPU clock rate in MHz (whole increments only) and used as a multiplier
;
delay_6551:
	phy				;Save Y Reg
	phx				;Save X Reg
	ldy		#8		;Get delay value (clock rate in MHz 8 clock cycles)
	; ldy		#1		;Get delay value (clock rate in MHz 1 clock cycles)

@clock_loop:
	ldx		#$CC	;Seed X reg, $11 works for 115200 baud, $66 for 19200, $CC for 9600
@baud_loop:
	dex				;Decrement low index
	bne		@baud_loop	 ;Loop back until done
	dey				;Decrease by one
	bne		@clock_loop	 ;Loop until done
	plx				;Restore X Reg
	ply				;Restore Y Reg
	rts				;Delay done, return
