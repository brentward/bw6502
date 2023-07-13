.segment "BIOS"
;******************************************************************************
; $F800	;2KB reserved for BIOS
;******************************************************************************
;START OF BIOS CODE
;******************************************************************************
; C02BIOS version used here is 1.4
;
; Contains the base BIOS routines in top 1KB of EEPROM
; - Pages $F8/$F9 512 bytes for BIOS (65C51/65C22), NMI Panic routine
; - Pages $FA-$ED reserved for BIOS expansion
; - Page $02 reserved for HW (8-I/O devices, 16 bytes wide and 1-I/O device, 128 bytes wide)
; - Page ($FF) JMP table, CPU startup, 64 bytes Soft Vectors and HW Config data
;		- does I/O init and handles NMI/BRK/IRQ pre-/post-processing routines
;		- sends BIOS message string to console
;	- Additional code added to handle XMODEM transfers
;		- allows a null character to be received into the buffer
;		- CRC bytes can be zero, original code would invoke BRK routine
;		- Uses the XMFLAG flag which is set/cleared during Xmodem xfers
;		- Now uses BBR instruction to check XMFLAG - saves a byte
;		-	Now uses BBR instruction to check BRK condition - saves a byte
; - BEEP moved to main monitor code, JMP entry replaced with CHRIN_NW
; - Input/Feedback from "BDD" - modified CHR-I/O routines - saves 12 bytes
;******************************************************************************
;	The following 16 functions are provided by BIOS and available via the JMP
;	Table as the last 16 entries from $FF48 - $FF75 as:
;	$FF48 CHRIN_NW (character input from console, no waiting, set carry if none)
;	$FF4B CHRIN (character input from console)
;	$FF4E CHROUT (character output to console)
;	$FF51 SETDLY (set delay value for milliseconds and 16-bit counter)
;	$FF54 MSDELAY (execute millisecond delay 1-256 milliseconds)
;	$FF57 LGDELAY (execute long delay; millisecond delay * 16-bit count)
;	$FF5A XLDELAY (execute extra long delay; 8-bit count * long delay)
;	$FF5D SETPORT (set VIA port A or B for input or output)
;	$FF60 RDPORT (read from VIA port A or B)
;	$FF63 WRPORT (write to VIA port A or B)
;	$FF66 INITVEC (initialize soft vectors at $0300 from ROM)
;	$FF69 INITCFG (initialize soft config values at $0320 from ROM)
;	$FF6C INITCON (initialize 65C51 console 19.2K, 8-N-1 RTS/CTS)
;	$FF6F INITVIA (initialize 65C22 default port, timers and interrupts)
;	$FF72 MONWARM (warm start Monitor - jumps to page $03)
;	$FF75 MONCOLD (cold start Monitor - jumps to page $03)
;******************************************************************************
; Character In and Out routines for Console I/O buffer
;******************************************************************************
;
;CHRIN routines
;CHRIN_NW uses CHRIN, returns if a character is not available from the buffer
; with carry flag clear, else returns with character in A reg and carry flag set
;CHRIN waitd for a character to be in the buffer, then returns with carry flag set
;	receive is IRQ driven / buffered with a fixed size of 128 bytes
;
CHRIN_NW	CLC	;Clear Carry flag for no character (2)
					LDA	ICNT	;Get character count (3)
					BNE	GET_CH	;Branch if buffer is not empty (2/3)
					RTS	;and return to caller (6)
;
;CHRIN waits for a character and retuns with it in the A reg
;
CHRIN			LDA	ICNT	;Get character count (3)
					BEQ	CHRIN	;If zero (no character, loop back) (2/3)
;
GET_CH		PHY	;Save Y reg (3)
					LDY	IHEAD	;Get the buffer head pointer (3)
					LDA	IBUF,Y	;Get the character from the buffer (4)
;
					INC	IHEAD	;Increment head pointer (5)
					RMB7	IHEAD	;Strip off bit 7, 128 bytes only (5)
;
					DEC	ICNT	;Decrement the buffer count (5)
					PLY	;Restore Y Reg (4)
					SEC	;Set Carry flag for character available (2)
					RTS	;Return to caller with character in A reg (6)
;
;CHROUT routine: takes the character in the A reg and places it in the xmit buffer
; the character sent in the A reg is preserved on exit
;	transmit is IRQ driven / buffered with a fixed size of 128 bytes
;
;	- 8/10/2014 - modified this routine to always set the Xmit interrupt active with each
;	character placed into the output buffer. There appears to be a highly intermittant bug
;	in both the 6551 and 65C51 where the Xmit interrupt turns itself off, the code itself
;	is not doing it as the OIE flag was never reset and this only happens in the IRQ routine
;	The I/O and service routines now appear to work in a stable manner on all 6551 and 65C51
;	Note: OIE flag no longer needed/used due to bug workaround
;
CHROUT
				STA SIODAT
				JSR delay_6551
				RTS

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


; CHROUT		PHY	;save Y reg	(3)
; OUTCH			LDY	OCNT	;get character output count in buffer	(3)
; 					BMI	OUTCH	;check against limit, loop back if full	(2/3)
; ;
; 					LDY	OTAIL	;Get the buffer tail pointer	(3)
; 					STA	OBUF,Y	;Place character in the buffer	(5)
; ;
; 					INC	OTAIL	;Increment Tail pointer (5)
; 					RMB7	OTAIL	;Strip off bit 7, 128 bytes only (5)
; 					INC	OCNT	;Increment character count	(5)
; ;
; 					LDY	#$01	;Get mask for xmit on	(2)
; 					STY	SIOCOM	;Turn on xmit irq	(4)
; ;
; OUTC2			PLY	;Restore Y reg	(4)
; 					RTS	;Return	to caller (6)
;
;******************************************************************************
;SET DELAY routine
; This routine sets up the MSDELAY values and can also set the Long Delay variable
; On entry, A reg = millisecond count, X reg = High multipler, Y reg = Low multipler
;	these values are used by the EXE_MSDLY and EXE_LGDLY routines
;	values for MSDELAY are $00-$FF ($00 = 256 times)
;	values for Long Delay are $0000-$FFFF (0-65535 times)
;	longest delay is 65,535*256*1ms = 16,776,960 * 0.001 = 16,776.960 seconds
;
SET_DLY		STA	SETIM	;Save millisecond count (3)
					STY	DELLO	;Save Low multipler (3)
					STX	DELHI	;Save High Multipler (3)
					RTS	;Return to caller (6)
;
;EXE MSDELAY routine
;	This routine is the core delay routine
;	It sets the count value from SETIM variable, enables the MATCH flag, then starts
;	Timer 2 and waits for the IRQ routine to decrement to zero and clear the MATCH flag
;	note: 3 clock cycles (JMP table) to get here on a standard call
;	- 11 clock cycles to start T2, 15 clock cycles to return after MATCH cleared
;	- starting T2 first to help normalize overall delay time
;	- total of 37 clock cycles overhead in this routine
;
EXE_MSDLY	PHA	;Save A Reg (3)
					LDA	LOAD_6522+$07	;Get T2H value (4)
					STA	Via1T2CH	;Reload T2 and enable interrupt (4)
					SMB7	MATCH	;Set MATCH flag bit (5)
					LDA	SETIM	;Get delay seed value (3)
					STA	MSDELAY	;Set MS delay value (3)
;
MATCH_LP	BBS7	MATCH,MATCH_LP	;Test MATCH flag, loop until cleared (5)
					PLA	;Restore A Reg (4)
					RTS	;Return to caller (6)
;
;EXE LONG Delay routine
;	This routine is the 16-bit multiplier for the MS DELAY routine
;	It loads the 16-bit count from DELLO/DELHI, then loops the MSDELAY
;	routine until the 16-bit count is decremented to zero
;
EXE_LGDLY	PHX	;Save X Reg (4)
					PHY	;Save Y Reg (4)
					LDX	DELHI	;Get high byte count (3)
					INX	;Increment by one (checks for $00 vs $FF) (2)
					LDY	DELLO	;Get low byte count (3)
					BEQ	SKP_DLL	;If zero, skip to high count (2/3)
DO_DLL		JSR	EXE_MSDLY	;Call millisecond delay (6)
					DEY	;Decrement low count (2)
					BNE	DO_DLL	;Branch back until done (2/3)
;
SKP_DLL		DEX	;Decrement high byte index (2)
					BNE	DO_DLL	;Loop back to DLL (will run 256 times) (2/3)
					PLY	;Restore Y Reg (3)
					PLX	;Restore X Reg (3)
					RTS	;Return to caller (6)
;
;EXE EXTRA LONG Delay routine
;	This routine uses XDL variable as an 8-bit count
;	and calls the EXE LONG Delay routine XDL times
;	- On entry, XDL contains the number of interations
EXE_XLDLY	JSR	EXE_LGDLY	;Call the Long Delay routine (6)
					DEC	XDL	;Decrement count (5)
					BNE	EXE_XLDLY	;Loop back until XDL times out (2/3)
					RTS	;Done, return to caller (6)
;	
;******************************************************************************
; I/O PORT routines for 6522
;	- Allows port A or B setup for input or output
;	- Allows data to be read from Port A or B
;	- Allows data to be written to Port A or B
;	- Routines are Non-buffered and no HW handshaking
;	- Page zero variables are used: IO_DIR, IO_IN, IO_OUT
;
;	6522 Port Config routine
;	- Allows Port A or B to be configured for input or output
;	- On entry, X reg contains port number (1=A, 0=B)
;	- A reg contains config mask; bit=0 for Input, bit=1 for Output
;	- on exit, A reg contain Port DDR value, X reg contains port #
;	- Carry set if error, cleared if OK
;
SET_PORT	STA	Via1DDRB,X	;Store config Mask to the correct port (5)
					STA	IO_DIR	;Save Mask for compare (3)
					LDA	Via1DDRB,X	;Load config Mask back from port (4)
					CMP	IO_DIR	;Compare to config MASK (3)
					BCS	PORT_OK	;Branch if same (2/3)
					SEC	;Set Carry for bad compare (2)
					RTS	;Return to caller (6)
PORT_OK		CLC	;Clear Carry flag for no error (2)
					RTS	;Return to caller (6)
;
;	Port Input routine
;	- On entry, X reg contains port number (1=A, 0=B)
;	- On exit, A reg contains read data, X reg contains port #
;	- Carry set if error on read, cleared if OK
;	- Requested Port is read twice and compared for error,
;	- this implies port data input does not change too quickly
;
IN_PORT		LDA	Via1PRB,X	;Read Port data (4)
					STA	IO_IN	;Save Read data (3)
					LDA	Via1PRB,X	;Read Port a second time (4)
					CMP	IO_IN	;Compare against previous read (3)
					BCS	PORT_OK	;Branch if same (2/3)
					SEC	;Set Carry for bad compare (2)
					RTS	;Return to caller (6)
;
;	Port Output routine
;	- On entry, X reg contains port number (1=A, 0=B)
;	- A reg contain data to write to port
;	- On exit, A reg contains Port data, X reg contains port #
;	- Carry set if error on write, cleared if OK
;
OUT_PORT	STA	Via1PRB,X	;Write Port data (5)
					STA	IO_OUT	;Save data to output to port (3)
					LDA	Via1PRB,X	;Read Port data back (4)
					CMP	IO_OUT	;Compare against previous read (3)
					BCS	PORT_OK	;Branch if same (2/3)
					SEC	;Set Carry for bad compare (2)
					RTS	;Return to caller (6)
;
;******************************************************************************
;
;START OF PANIC ROUTINE
; The Panic routine is for debug of system problems, i.e., a crash
; The design requires a debounced NMI trigger button which is manually operated
; when the system crashes or malfunctions, press the NMI (panic) button
; The NMI vectored routine will perform the following tasks:
; 1- Save registers in page $00
; 2- Save pages $00, $01, $02 and $03 at location $0400-$07FF
; 3- Overlay the I/O page ($FE) at location $0780
; 4- Zero I/O buffer pointers
; Call the ROM routines to init the vectors and config data (page $03)
; Call ROM routines to init the 6551 and 6522 devices
; Restart the Monitor via warm start vector
; No memory is cleared except the required pointers to restore the system
;	- suggest invoking the Register command afterwards to get the details saved
;
NMI_VECTOR	;This is the ROM start for NMI Panic handler
					STA	AREG	;Save A Reg (3)
					STX	XREG	;Save X Reg (3)
					STY	YREG	;Save Y Reg (3)
					PLA	;Get Processor Status 	      (3)   
					STA	PREG	;Save in PROCESSOR STATUS preset/result (3)
					TSX	;Get Stack pointer (2)
					STX	SREG	;Save STACK POINTER (3)
					PLA	;Pull RETURN address from STACK (3)
					STA	PCL	;Store Low byte (3)
					PLA	;Pull high byte (3)
					STA	PCH	;Store High byte (3)
;
					LDY	#$00	;Zero Y reg (2)
					LDX	#$04	;Set index to 4 pages (2)
					STX	$03	;Set to high order (3)
					STZ	$02	;Zero remaining pointers (3)
					STZ	$01 ;(3)
					STZ	$00 ;(3)
;
PLP0			LDA	($00),Y	;get byte (4)
					STA	($02),Y	;store byte (6)
					DEY	;Decrement index (2)
					BNE	PLP0	;Loop back till done (2/3)
;
					INC	$03	;Increment page address (5)
					INC	$01	;Increment page address (5)
					DEX	;Decrement page index (2)
					BNE	PLP0	;Branch back and do next page (2/3)
;					
IO_LOOP		LDA	$FE00,X	;Get I/O Page (X reg already at #$00) (4)
					STA	$0780,X	;Overlay I/O page to Vector Save (5)
					INX	;Increment index (2)
					BPL	IO_LOOP	;Loop back until done (128 bytes) (2/3)
;
					LDX	#$06	;Get count of 6 (2)
PAN_LP1		STZ	ICNT-1,X	;Zero out console I/O pointers (4)
					DEX	;Decrement index (2)
					BNE	PAN_LP1	;Branch back till done (2/3)
;
					JSR	INIT_PG03	;Xfer default Vectors/HW Config to $0300 (6)
					JSR	INIT_IO	;Init I/O - Console, Timers, Ports (6)
;
					JMP	(NMIRTVEC0)	;Jump to Monitor Warm Start Vector (5)
;
;*************************************
;* BRK/IRQ Interrupt service routine *
;*************************************
;
;The pre-process routine located in page $FF soft-vectors to here:
;	The following routines handle BRK and IRQ
;	The BRK handler saves CPU details for register display
;	- A Monitor can provide a disassembly of the last executed instruction
;	- An ASCII null character ($00) is also handled here
;
;6551 handler
;	The 6551 IRQ routine handles both transmit and receive via IRQ
;	- each has it's own 128 circular buffer
;	- Xmit IRQ is controlled by the handler and the CHROUT routine
;
;6522 handler
; The 6522 IRQ routine handles Timer1 interrupts used for a RTC
;	- resolution is set for 4ms (250 interrupts per second)
;	- recommended CPU clock rate is 2MHz minimum
; Timer2 provides an accurate delay with resolution to 1ms
;	- timer service/match routine are IRQ driven with dedicated handler
;
BREAKEY		CLI	;Enable IRQ (2)
;
BRKINSTR0	PLY	;Restore Y reg (4)
					PLX	;Restore X Reg (4)
					PLA	;Restore A Reg (4)
					STA	AREG	;Save A Reg (3)
					STX	XREG	;Save X Reg (3)
					STY	YREG	;Save Y Reg (3)
					PLA	;Get Processor Status (4)	        
					STA	PREG	;Save in PROCESSOR STATUS preset/result (2)
					TSX	;Xfrer STACK pointer to X reg (2)
					STX	SREG	;Save STACK pointer (4)
;
					PLX	;Pull Low RETURN address from STACK then save it (4)
					STX	PCL	;Store program counter Low byte (3)
					STX	INDEXL	;Seed Indexl for DIS_LINE (3)
					PLY	;Pull High RETURN address from STACK then save it (4)
					STY	PCH	;Store program counter High byte (3)
					STY	INDEXH	;Seed Indexh for DIS_LINE (3)
					BBR4	PREG,DO_NULL	;Check for BRK bit set (5)
;
; The following three subroutines are contained in the base Monitor code
; These calls do a register display and disassembles the line of code
; that caused the BRK to occur. Other code can be added if required
;	- if replaced with new code, either replace or remove this routine
;
					JSR	PRSTAT1	;Display CPU status (6)
					JSR	DECINDEX	;Decrement Index location (point to BRK ID Byte) (6)
					JSR	DIS_LINE	;Disassemble current instruction (6)
;
DO_NULL		LDA	#$00	;Clear all PROCESSOR STATUS REGISTER bits (2)
					PHA	; (3)
					PLP	; (4)
					STZ	ITAIL	;Zero out input buffer / reset pointers (3)
					STZ	IHEAD	; (3)
					STZ	ICNT	; (3)
					JMP	(BRKRTVEC0)	;Done BRK service process, re-enter monitor (3)
;
;new full duplex IRQ handler (54 clock cycles overhead to this point - includes return)
;
INTERUPT0	LDA	SIOSTAT	;Get status register, xfer irq bit to n flag (4)
					BPL	REGEXT	;if clear no 6551 irq, exit, else (2/3) (7 clock cycles to exit - take branch)
;
ASYNC			BIT #%00001000	;check receive bit (2)
					BNE RCVCHR	;get received character (2/3) (11 clock cycles to jump to RCV)
					; BIT #%00010000	;check xmit bit (2)
					; BNE XMTCHR	;send xmit character (2/3) (15 clock cycles to jump to XMIT)
;no bits on means CTS went high
					ORA #%00010000 ;add CTS high mask to current status (2)
IRQEXT		STA STTVAL ;update status value (3) (19 clock cycles to here for CTS fallout)
;
REGEXT		JMP	(IRQRTVEC0) ;handle next irq (5)
;
BUFFUL		LDA #%00001100 ;buffer overflow flag (2)
					BRA IRQEXT ;branch to exit (3)
;
RCVCHR		LDA SIODAT	;get character from 6551 (4)
					BNE	RCV0	;If not a null character, handle as usual and put into buffer	(2/3)
					BBR6	XMFLAG,BREAKEY	;If Xmodem not active, handle BRK (5)
;
RCV0			LDY ICNT	;get buffer counter (3)
					BMI	BUFFUL	;check against limit, branch if full (2/3)
;
					LDY ITAIL ;room in buffer (3)
					STA IBUF,Y ;store into buffer (5)
					INC	ITAIL	;Increment tail pointer (5)
					RMB7	ITAIL	;Strip off bit 7, 128 bytes only (5)
					INC ICNT ;increment character count (5)
;	
					LDA SIOSTAT ;get 6551 status reg (4)
					AND #%00010000 ;check for xmit (2)
					BEQ REGEXT	;exit (2/3) (40 if exit, else 39 and drop to XMT)
;
XMTCHR		LDA OCNT ;any characters to xmit? (3)
					BEQ NODATA ;no, turn off xmit (2/3)
;
OUTDAT		LDY OHEAD ;get pointer to buffer (3)
					LDA OBUF,Y ;get the next character (4)
					STA SIODAT ;send the data (4)
;
					INC	OHEAD	;Increment Head pointer (5)
					RMB7	OHEAD	;Strip off bit 7, 128 bytes only (5)
					DEC OCNT ;decrement counter (5)
					BNE	REGEXT	;If not zero, exit and continue normal stuff (2/3) (31 if branch, 30 if continue)
;
NODATA		LDY	#$09	;get mask for xmit off / rcv on (2)
					STY SIOCOM ;turn off xmit irq bits (5)
					BRA REGEXT ;exit (3) (13 clock cycles added for turning off xmt)
;
;******************************************************************************
;
;Start of the 6522 BIOS code. Supports basic timer function
; A time of day clock is implemented with a resolution of 4ms
; Timer ticks is set at 250 ticks per second. Page zero holds
; all variables for ticks, seconds, minutes, hours, days
; To keep things simple, days is two bytes so can handle 0-65535 days,
; which is about 179 years. Additional calculations can be made if
; required for a particular application
;
;	Timer Delay Match routine:
;	This provides an accurate and consistent time delay
; using Timer 2 of the 6522. It is configured as a one-shot timer
;	set for 1 millisecond based on clock rate (see config table)
;	It uses an 8-bit value for countdown to reset a MATCH flag on timeout
;	Value can be 1-256 milliseconds ($00 = 256)
;	This routine must also reset the counter if MSDELAY has not decremented
;	to zero, which completes the timer delay
; The delay routine sets the MSDELAY value and MATCH flag to $80,
; then monitors the MATCH flag which is cleared after the delay
;
;	Note that each Timer has it's own exit vector. By default they point to the
;	following IRQ vector (6551 service routine). This allows either timer to be
;	used as a refresh routine by inserting additional code in either loop. The RTC
;	should not be changed, but Timer2 can be provided the user track it's use versus
;	the standard delay routines which also use Timer2
;	NOTE: 24 clock cycles via IRQ vector to get here
;
;Basic use of timer services includes:
;		RTC - time (relative timestamp)
;		Internal delay and timing routines
;		Background refresh tasks
;
INTERUPT1	LDA	Via1IFR	;Get IRQ flag register, xfer irq bit to n flag (4)
					BPL	REGEXT1	;if set, 6522 caused irq,(do not branch) (2/3) (7 clock cycles to exit - take branch)
					BIT	#%00100000	;check T2 interrupt bit (2)
					BNE	DECMSD	;If active, handle T2 timer (MS delay) (2/3)
					BIT #%01000000	;check T1 interrupt bit (2)
					BNE	INCRTC	;If active, handle T1 timer (RTC) (2/3)
; 					BIT #%00000010	;check CA1 interrupt bit (2)
; 					BEQ NO_KBD
; 					JSR kb_handle
; NO_KBD
					STA	STVVAL	;Save in status before exit (3)
					BRA REGEXT1	;branch to next IRQ source, exit (3)
;
DECMSD		BIT	Via1T2CL	;Clear interrupt for T2 (4)
					DEC	MSDELAY	;Decrement 1ms millisecond delay count (5)
					BNE	RESET_T2	;If not zero, re-enable T2 and exit (2/3)
					STZ	MATCH	;Else, clear match flag (3) (25 clock cycles to clear MATCH)
REGEXT2		JMP	(VECINSRT1)	;Done with timer handler, exit (5) 
;
RESET_T2	LDA	LOAD_6522+$07	;Get T2H value (4)
					STA	Via1T2CH	;Reload T2 and re-enable interrupt (4) (31 clock cycles to restart T2)
					BRA	REGEXT2	;Done with timer handler, exit (3)
;
INCRTC		BIT	Via1T1CL	;Clear interrupt for T1 (4)
					DEC	TICKS	;Decrement RTC tick count (5)
					BNE	REGEXT1	;Exit if not zero (2/3)
					LDA	#DF_TICKS ;Get default tick count (2)
					STA	TICKS	;Reset Tick count (3)
;
					INC	SECS	;Increment seconds (5)
					LDA	SECS	;Load it to Areg (3)
					CMP	#60	;Check for 60 seconds (2)
					BCC	REGEXT1	;If not, exit (2/3)
					STZ	SECS	;Else, reset seconds, inc Minutes (3)
;
					INC	MINS	;Increment Minutes (5)
					LDA	MINS	;Load it to Areg (3)
					CMP	#60	;Check for 60 minutes (2)
					BCC	REGEXT1	;If not, exit (2/3)
					STZ	MINS	;Else, reset Minutes, inc Hours (3)
;
					INC	HOURS	;Increment Hours (5)
					LDA	HOURS	;Get it to Areg (3)
					CMP	#24	;Check for 24 hours (2)
					BCC	REGEXT1	;If not, exit (2/3)
					STZ	HOURS	;Else, reset hours, inc Days (3)
;
					INC	DAYSL	;Increment low-order Days (5)
					BNE	REGEXT1	;If not zero, exit (2/3)
					INC	DAYSH	;Else increment high-order Days (5)
;
REGEXT1		JMP	(VECINSRT0) ;handle next irq (5)
;
INIT_PG03	JSR	INIT_VEC	;Init the Vectors first (6)
;
INIT_CFG	LDY	#$40	;Get offset to data (2)
					BRA	DATA_XFER	;Go move the data to page $03 (3)
INIT_VEC	LDY	#$20	;Get offset to data (2)
;
DATA_XFER	SEI	;Disable Interrupts, can be called via JMP table (2)
					LDX	#$20	;Set count for 32 bytes (2)
DATA_XFLP
					LDA	VEC_TABLE-1,Y	;Get ROM table data (4)
					STA	SOFTVEC-1,Y	;Store in Soft table location (5)
					DEY	;Decrement index (2)
					DEX	;Decrement count (2)
					BNE	DATA_XFLP	;Loop back till done (2/3)
					CLI	;re-enable interupts (2)
					RTS	;Return to caller (6)
;
INIT_6551
;Init the 65C51
					SEI	;Disable Interrupts (2)
					STZ	SIOSTAT	;write to status reg, reset 6551 (3)
					STZ	STTVAL	;zero status pointer (3)
					LDX	#$02	;Get count of 2 (2)
INIT_6551L
					LDA	LOAD_6551-1,X	;Get Current 6551 config parameters (4)
					STA	SIOBase+1,X	;Write to current 6551 device (5)
					DEX	;Decrement count (2)
					BNE	INIT_6551L	;Loop back until done (2/3)
					CLI	;Re-enable Interrupts (2)
					RTS	;Return to caller (6)
;
INIT_IO		JSR	INIT_6551	;Init the Console first (6)
;
INIT_6522
;Init the 65C22
					SEI	;Disable Interrupts (2)
					STZ	STVVAL	;zero status pointer (3)
					LDX  #$0D	;Get Count of 13 (2)
INIT_6522L
					LDA	LOAD_6522-1,X	;Get soft parameters (4)
					STA	Via1Base+1,X	;Load into 6522 chip (5)
					DEX	;Decrement to next parameter (2)
					BNE	INIT_6522L	;Branch back till all are loaded (2/3)
					CLI	;Re-enable IRQ (2)
; INIT_KBD
; 					JSR kb_init

RET				RTS	;Return to caller (6)
;
;END OF BIOS CODE
