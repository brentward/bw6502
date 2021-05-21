; in_buffer = $0400   ; 256 bytes 0x0400-0x04FF

; io_init:
; 	stz in_wptr
; 	stz in_rptr
; 	rts

; buf_write:  
; 	ldx  in_wptr        ; Start with A containing the byte to put in the buffer.
; 	sta  in_buffer,x    ; Get the pointer value and store the data where it says,
; 	inc  in_wptr        ; then increment the pointer for the next write.
; 	rts
;  ;-------------

; buf_read: 
; 	ldx  in_rptr        ; Ends with a containing the byte just read from buffer.
; 	lda  in_buffer,x    ; Eet the pointer value and read the data it points to.
; 	inc  in_rptr        ; Then increment the pointer for the next read.
; 	rts
;  ;-------------

; buf_dif:
; 	lda in_wptr         ; Find difference between number of bytes written
; 	sec                 ; and how many read.
; 	sbc in_rptr         ; Ends with a showing the number of bytes left to read.
; 	rts
;  ;-------------

; ibuf			=	$0400	;INPUT BUFFER  128 BYTES - BIOS use only
; obuf			=	$0480	;OUTPUT BUFFER 128 BYTES - BIOS use only


; ;******************************************************************************
; ; Character In and Out routines for Console I/O buffer
; ;******************************************************************************
; ;
; ;CHRIN routines
; ;CHRIN_NW uses CHRIN, returns if a character is not available from the buffer
; ; with carry flag clear, else returns with character in A reg and carry flag set
; ;CHRIN waitd for a character to be in the buffer, then returns with carry flag set
; ;	receive is IRQ driven / buffered with a fixed size of 128 bytes
; ;
; CHRIN_NW	CLC	:Clear Carry flag for no character (2)
; 					LDA	icnt	;Get character count (3)
; 					BNE	GET_CH	;Branch if buffer is not empty (2/3)
; 					RTS	;and return to caller (6)
; ;
; ;CHRIN waits for a character and retuns with it in the A reg
; ;
; CHRIN			LDA	icnt	;Get character count (3)
; 					BEQ	CHRIN	;If zero (no character, loop back) (2/3)
; ;
; GET_CH		PHY	;Save Y reg (3)
; 					LDY	ihead	;Get the buffer head pointer (3)
; 					LDA	ibuf,Y	;Get the character from the buffer (4)
; ;
; 					INC	ihead	;Increment head pointer (5)
; 					RMB7	ihead	;Strip off bit 7, 128 bytes only (5)
; ;
; 					DEC	icnt	;Decrement the buffer count (5)
; 					PLY	;Restore Y Reg (4)
; 					SEC	;Set Carry flag for character available (2)
; 					RTS	;Return to caller with character in A reg (6)
; ;
; ;CHROUT routine: takes the character in the A reg and places it in the xmit buffer
; ; the character sent in the A reg is preserved on exit
; ;	transmit is IRQ driven / buffered with a fixed size of 128 bytes
; ;
; ;	- 8/10/2014 - modified this routine to always set the Xmit interrupt active with each
; ;	character placed into the output buffer. There appears to be a highly intermittant bug
; ;	in both the 6551 and 65C51 where the Xmit interrupt turns itself off, the code itself
; ;	is not doing it as the OIE flag was never reset and this only happens in the IRQ routine
; ;	The I/O and service routines now appear to work in a stable manner on all 6551 and 65C51
; ;	Note: OIE flag no longer needed/used due to bug workaround
; ;
; ; CHROUT		PHY	;save Y reg	(3)
; ; OUTCH			LDY	ocnt	;get character output count in buffer	(3)
; ; 					BMI	OUTCH	;check against limit, loop back if full	(2/3)
; ; ;
; ; 					LDY	otail	;Get the buffer tail pointer	(3)
; ; 					STA	obuf,Y	;Place character in the buffer	(5)
; ; ;
; ; 					INC	otail	;Increment Tail pointer (5)
; ; 					RMB7	otail	;Strip off bit 7, 128 bytes only (5)
; ; 					INC	ocnt	;Increment character count	(5)
; ; ;
; ; 					LDY	#$05	;Get mask for xmit on	(2)
; ; 					STY	SIOCOM	;Turn on xmit irq	(4)
; ; ;
; ; OUTC2			PLY	;Restore Y reg	(4)
; ; 					RTS	;Return	to caller (6)

;CHOUT subroutine: takes the character in the ACCUMULATOR and places it in the xmit buffer
;this routine also preserves the character sent in the A reg on exit (standard one did also)
;   new routine to work with the new IRQ service routine for the 6551
; now transmit is IRQ driven and buffered
;   the output buffer is fixed at 128 bytes, so buffer management is added
;
CHOUT         PHY ;save Y reg
OUTCH         LDY OCNT ;get character output count in buffer
               BMI   OUTCH   ;check against limit, loop back if full
;
               PHP   ;Save IRQ state
               SEI ;Disable irq
               LDY OTAIL ;Get index to next spot
               STA OBUF,Y ;and place in buffer
               INY ;Increment index
               BPL   OUTC1   ;Check for wrap-around ($80), branch if not
               LDY #$00 ;Yes, zero pointer
;
OUTC1         STY OTAIL ;Update pointer
               INC OCNT ;Increment character count
               BIT OIE ;Is xmit on?
               BMI OUTC2 ;Yes, operation done
;
               LDY   #$05   ;Get mask for xmit on
               STY SIOCOM ;Turn on xmit irq
               DEC OIE ;Update flag
;
OUTC2         PLP   ;Restore IRQ flag
               PLY   ;Restore Y reg
               RTS ;Return
;
;CHIN subroutine: Wait for a keystroke from input buffer, return with keystroke in A Reg
;   new routine to work with the new IRQ service routine for the 6551
;   the input buffer is fixed at 128 bytes, so buffer management is replaced
;
CHIN         LDA   ICNT   ;Get character count
               BEQ   CHIN   ;If zero (no character, loop back)
;
               PHY   ;Save Y reg
               PHP   ;Save CPU flag set
               SEI   ;Disable IRQ to work with buffer pointers
               LDY   IHEAD   ;Get the buffer head pointer
               LDA   IBUF,Y   ;Get the character from the buffer
               INY   ;Increment the buffer index
               BPL   CHIN1   ;Check for wraparound ($80), branch if not
               LDY   #$00   ;Reset the buffer pointer
CHIN1         STY   IHEAD   ;Update buffer pointer
               DEC   ICNT   ;Decrement the buffer count
               PLP   ;Restore previous CPU flags (IRQ)
               PLY   ;Restore Y Reg
               RTS   ;Return to caller with character in A reg
;
