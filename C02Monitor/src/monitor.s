;
;***************************************************
;*  C02Monitor 1.4 (c)2013-2017 by Kevin E. Maier  *
;*    Extendable BIOS and Monitor for 65C02 CPU    *
;*                                                 *
;* Basic functions include:                        *
;*  - Byte/Text memory search                      *
;*  - CPU register display/modify                  *
;*  - Memory fill, move, compare, examine/edit     *
;*  - Xmodem/CRC Loader with S-Record support      *
;*  - Input buffer Macro utility up to 127 bytes   *
;*  - EEPROM Program utility (Atmel Byte-write)    *
;*  - RTC via 65C22 showing time since boot        *
;*  - 1ms timer delay via 65C22                    *
;*  - Table-driven Disassembler for W65C02S        *
;*  - Monitor space increased for future expansion *
;*  - Monitor version change to match BIOS version *
;*  - Added Loop Counter for Macro operation       *
;*                                                 *
;*                  07/11/17 KM                    *
;*   Uses <6KB EEPROM - JMP table page at $FF00    *
;*     Uses one page for I/O: default at $FE00     *
;*         Default assembly start at $E000:        *
;*                                                 *
;*  C02BIOS 1.4 (c)2013-2017 by Kevin E. Maier     *
;*  - BIOS in pages $F8-$FD, $FF                   *
;*  - Full duplex interrupt-driven/buffered I/O    *
;*  - extendable BIOS structure with soft vectors  *
;*  - soft config parameters for all I/O devices   *
;*  - monitor cold/warm start soft vectored        *
;*  - fully relocatable code (sans page $FF)       *
;*  - precision timer services 1ms accuracy        *
;*  - delays from 1ms to 49.71 days                *
;*  - basic port services for 6522 VIA             *
;*  - moved BEEP to main Monitor, CHRIN_NW in BIOS *
;*  - BIOS space increased for future expansion    *
;*                                                 * 
;*   Note default HW system memory map as:         *
;*         RAM - $0000 - $01FF                     *
;*         I/O - $0200 - $02FF                     *
;*         RAM - $0300 - $7FFF                     *
;*         ROM - $8000 - $FFFF                     *
;*                                                 *
;***************************************************
;
	; PL	66	;Page Length
	; PW	132	;Page Width (# of char/line)
	; CHIP	W65C02S	;Enable WDC 65C02 instructions
	; PASS1	OFF	;Set ON when used for debug
;
.pagelength 66
.setcpu "65C02"

	.include "zeropage.s"
	.include "basic.s"
	.include "bios.s"
	; .include "keyboard.s"
	.include "top.s"

;******************************************************************************
;******************************************************************************
;Character input buffer address: $0300-$037F - 128 bytes
;Character output buffer address: $0380-$03FF - 128 bytes
;Managed by full-duplex IRQ service routine
;
IBUF			=	$0300	;INPUT BUFFER  128 BYTES - BIOS use only
OBUF			=	$0380	;OUTPUT BUFFER 128 BYTES - BIOS use only
;
;******************************************************************************
SOFTVEC		=	$0400	;Start of soft vectors
;
;The Interrupt structure is vector based. During startup, Page $03 is loaded from ROM
; The soft vectors are structured to allow inserting additional routines either before
; or after the core routines. This allows flexibility and changing of routine priority
;
;The main set of vectors occupy the first 16 bytes of Page $03. The ROM handler for
; NMI, BRK and IRQ jump to the first 3 vectors. The following 3 vectors are loaded with
; returns to the ROM handler for each. The following 2 vectors are the cold and warm
; entry points for the Monitor. After the basic initialization, the monitor is entered
;
;The following vector set allows inserts for any of the above vectors
; there are a total of 8 Inserts which occupy 16 bytes. They can be used as required
; note that the first two are used for the 6522 timer routines
;
NMIVEC0		=	SOFTVEC	;NMI Interrupt Vector 0
BRKVEC0		=	SOFTVEC+2	;BRK Interrupt Vector 0
IRQVEC0		=	SOFTVEC+4	;INTERRUPT VECTOR 0
;
NMIRTVEC0	=	SOFTVEC+6	;NMI Return Handler 0
BRKRTVEC0	=	SOFTVEC+8	;BRK Return Handler 0
IRQRTVEC0	=	SOFTVEC+10	;IRQ Return Handler 0
;
CLDMNVEC0	=	SOFTVEC+12	;Cold Monitor Entry Vector 0
WRMMNVEC0	=	SOFTVEC+14	;Warm Monitor Entry Vector 0
;
VECINSRT0	=	SOFTVEC+16	;1st Vector Insert (Timer support)
VECINSRT1	=	SOFTVEC+18	;1st Vector Insert (Timer support)
VECINSRT2	=	SOFTVEC+20	;1st Vector Insert
VECINSRT3	=	SOFTVEC+22	;1st Vector Insert
VECINSRT4	=	SOFTVEC+24	;1st Vector Insert
VECINSRT5	=	SOFTVEC+26	;1st Vector Insert
VECINSRT6	=	SOFTVEC+28	;1st Vector Insert
VECINSRT7	=	SOFTVEC+30	;1st Vector Insert
;
;******************************************************************************
SOFTCFG		= SOFTVEC+32	;Start of hardware config parameters
;
;Soft Config values below are loaded from ROM and are the default I/O setup
;configuration data that the INIT_65xx routines use. As a result, you can write a
;routine to change the I/O configuration data and use the standard ROM routines
;to initialize the I/O without restarting or changing ROM. A Reset (cold or coded)
;will reinitialize the I/O with the ROM default I/O configuration
;
;There are a total of 32 Bytes configuration data reserved starting at $0320
;
LOAD_6551	=	SOFTCFG	;6551 SOFT config data start
LOAD_6522	=	SOFTCFG+2	;6522 SOFT config data start
;
;Defaults for RTC ticks - number of IRQs for 1 second
DF_TICKS	=	250	;clock timer set for 4 milliseconds, so 250 x 4ms = 1 second
;
; Search Buffer is 16 bytes in length
; Used to hold search string for text and hex data
SRCHBUFF	=	$440	;Located in Page $04 following HW config data
;
; Xmodem/CRC Loader also provides Motorola S19 Record sense and load
; Designed to handle the S19 records from the WDC Assembler/Linker package
; This requires a 44 byte buffer to parse each valid S1 record
; Located just before the 132 Byte Xmodem frame buffer
; There are a total of 176 bytes of Buffer associated with the Xmodem/CRC Loader
;
; Valid S-record headers are "S1" and "S9"
; For S1, the maximum length is "19" hex. The last S1 record can be less
; S9 record is always the last record with no data
; WDC Linker also appends a CR/LF to the end of each record for a total 44 bytes
;
SRBUFF		=	$0450	;Start of Motorola S-record buffer, 44 bytes in length
;
; Xmodem frame buffer. The entire Xmodem frame is buffered here and then checked
; for proper header and frame number, CRC-16 on the data, then moved to user RAM
;
RBUFF			=	$047C	;Xmodem temp 132 byte receive buffer
;
;Additional Xmodem variables, etc.
;
; XMODEM Control Character Constants
SOH				=	$01	;Start of Block Header
EOT				=	$04	;End of Text marker
ACK				=	$06	;Good Block Acknowledge
NAK				=	$15	;Bad Block acknowledged
CAN				=	$18	;Cancel character
;
;******************************************************************************
;
BURN_BYTE	=	$0000	;Location in RAM for BYTE write routine
;
;******************************************************************************
;I/O Page Base Address
IOPAGE		=	$0200  
;
;VIA1 device address:
Via1Base	=	IOPAGE+$10	;65C22 VIA base address here
Via1PRB		=  Via1Base+0	;Port B I/O register
Via1PRA		=  Via1Base+1	;Port A I/O register
Via1DDRB	=  Via1Base+2	;Port B data direction
Via1DDRA  =  Via1Base+3	;Port A data direction
Via1T1CL  =  Via1Base+4	;Timer 1 Low byte count
Via1T1CH  =  Via1Base+5	;Timer 1 High byte count
Via1T1LL  =  Via1Base+6	;Timer 1 Low byte latch
Via1TALH  =  Via1Base+7	;Timer 1 High byte latch
Via1T2CL  =  Via1Base+8	;Timer 2 Low byte count/latch
Via1T2CH  =  Via1Base+9	;Timer 2 High byte count
Via1SR    =  Via1Base+10	;Shift Register
Via1ACR   =  Via1Base+11	;Aux control register
Via1PCR   =  Via1Base+12	;Peripheral control register
Via1IFR   =  Via1Base+13	;Interrupt flag register
Via1IER   =  Via1Base+14	;Interrupt enable register
Via1PRA1  =  Via1Base+15	;Port A echo register
;
;VIA2 device address:
Via2Base	=	IOPAGE	;65C22 VIA base address here
Via2PRB		=  Via2Base+0	;Port B I/O register
Via2PRA		=  Via2Base+1	;Port A I/O register
Via2DDRB	=  Via2Base+2	;Port B data direction
Via2DDRA  =  Via2Base+3	;Port A data direction
Via2T1CL  =  Via2Base+4	;Timer 1 Low byte count
Via2T1CH  =  Via2Base+5	;Timer 1 High byte count
Via2T1LL  =  Via2Base+6	;Timer 1 Low byte latch
Via2TALH  =  Via2Base+7	;Timer 1 High byte latch
Via2T2CL  =  Via2Base+8	;Timer 2 Low byte count/latch
Via2T2CH  =  Via2Base+9	;Timer 2 High byte count
Via2SR    =  Via2Base+10	;Shift Register
Via2ACR   =  Via2Base+11	;Aux control register
Via2PCR   =  Via2Base+12	;Peripheral control register
Via2IFR   =  Via2Base+13	;Interrupt flag register
Via2IER   =  Via2Base+14	;Interrupt enable register
Via2PRA1  =  Via2Base+15	;Port A echo register
;
;ACIA device address:
SIOBase		=	IOPAGE+$20	;6551 Base HW address
SIODAT		=	SIOBase+0	;ACIA data register
SIOSTAT		=	SIOBase+1	;ACIA status register
SIOCOM		=	SIOBase+2 ;ACIA command register
SIOCON		=	SIOBase+3 ;ACIA control register
;
.segment "MONITOR"
;******************************************************************************
; $E000    ;6KB reserved for monitor $E000 through $F7FF
;******************************************************************************
;START OF MONITOR CODE
;*******************************************
;*                C02 Monitor              *
;*******************************************
;*  This is the Monitor Cold start vector  *
;*******************************************
MONITOR		LDA	#$14	;Get intro msg / BEEP
					JSR	PROMPT	;Send to terminal
;
;*******************************************
;*           Command input loop            *
;*******************************************
;*  This in the Monitor Warm start vector  *
;*******************************************
WRM_MON		LDX	#$FF	;Initialize Stack pointer
					TXS	;Xfer to stack
					STZ	CMDFLAG	;Clear Command flag
					LDA	#$16	;Get prompt msg
					JSR	PROMPT	;Send to terminal
;
CMON			JSR	RDCHAR	;Wait for keystroke (converts to upper-case)
					LDX	#MONTAB-MONCMD-1	;Get command list count
CMD_LP		CMP	MONCMD,X	;Compare to command list
					BNE	CMD_DEC	;Check for next command and loop
					PHA	;Save keystroke
					TXA	;Xfer Command index to A reg
					ASL	A	;Multiply keystroke value by 2
					TAX	;Get monitor command processor address from table MONTAB
					PLA	;Restore keystroke (some commands send keystroke to terminal)
					JSR	DOCMD	;Call selected monitor command processor as a subroutine
					BRA	WRM_MON	;Command processed, branch and wait for next command
DOCMD			JMP	(MONTAB,X)	;Execute CMD from Table
;
CMD_DEC		DEX	;Decrement index count
					BPL	CMD_LP	;If more to check, loop back
					JSR	BEEP	;Beep for error,
					BRA	CMON	;re-enter monitor
;
;***********************************************
;* Basic Subroutines used by multiple routines *
;***********************************************
;
;ASC2BIN subroutine: Convert 2 ASCII HEX digits to a binary (byte) value
;Enter: A register = high digit, Y register = low digit
;Return: A register = binary value
ASC2BIN		JSR	BINARY	;Convert high digit to 4-bit nibble
					ASL	A	;Shift to high nibble
					ASL	A
					ASL	A
					ASL	A
					STA	TEMP1	;Store it in temp area
					TYA	;Get Low digit
					JSR	BINARY	;Convert low digit to 4-bit nibble
					ORA	TEMP1	;OR in the high nibble
					RTS	;Return to caller
;
BINARY		SEC	;Set carry for subtraction
					SBC	#$30	;Subtract $30 from ASCII HEX digit
					CMP	#$0A	;Check for result < 10     
					BCC	BNOK	;Branch if 0-9
					SBC	#$07	;Else, subtract 7 for A-F
BNOK			RTS	;Return to caller
;
;BIN2ASC subroutine: Convert single byte to two ASCII HEX digits
;Enter: A register contains byte value to convert
;Return: A register = high digit, Y register = low digit
BIN2ASC		PHA	;Save A Reg on stack
					AND	#$0F	;Mask off high nibble
					JSR	ASCII	;Convert nibble to ASCII HEX digit
					TAY	;Move to Y Reg
					PLA	;Get character back from stack
					LSR	A	;Shift high nibble to lower 4 bits
					LSR	A
					LSR	A
					LSR	A
;
ASCII			CMP	#$0A	;Check for 10 or less
					BCC	ASOK	;Branch if less than 10
					CLC	;Clear carry for addition
					ADC	#$07	;Add $07 for A-F
ASOK			ADC	#$30	;Add $30 for ASCII
					RTS	;Return to caller
;
;HEX2ASC - Accepts 16-bit Hexadecimal value and converts to an ASCII decimal string
;Input is via the A and Y registers and output is up to 5 ASCII digits in DATABUFF
;The High Byte is in the Y register and Low Byte is in the A register
;Output data is placed in variable DATABUFF and terminated with an null character
;PROMPTR routine is used to print the ASCII decimal value
;Routine based on Michael Barry's code. Saved many bytes ;-)
;
HEX2ASC		STA	BINVALL	;Save Low byte
					STY	BINVALH	;Save High byte
					LDX	#5	;Get ASCII buffer offset
					STZ	DATABUFF,X	;Zero last buffer byte for null end
;
CNVERT		LDA	#$00	;Clear remainder
					LDY	#16	;Set loop count for 16-bits
;
DVLOOP		CMP	#$05	;Partial remainder >= 10/2
					BCC	DVLOOP2	;Branch if less
					SBC	#$05	;Update partial, set carry
;
DVLOOP2		ROL	BINVALL	;Shift carry into dividend
					ROL	BINVALH	;Which will be quotient
					ROL	A	;Rotate A reg
					DEY	;Decrement count
					BNE	DVLOOP	;Branch back until done
					ORA	#$30	;Or in bits for ASCII
;
					DEX	;Decrement buffer index
					STA	DATABUFF,X	;Store value into buffer
;
					LDA	BINVALL	;Get the Low byte
					ORA	BINVALH	;OR in the High byte (check for zero)
					BNE	CNVERT	;Branch back until done
					STX	TEMP1	;Save buffer offset
;
;Conversion is complete, get the string address,
;add offset, then call prompt routine and return
; note DATABUFF is fixed location in Page 0
; carry flag need not be cleared as result can never
; set flag after ADC instruction, Y Reg always zero
;
					LDA	#<DATABUFF	;Get Low byte Address
					ADC	TEMP1	;Add in buffer offset (no leading zeros)
					LDY	#>DATABUFF	;Get High byte address
					JMP	PROMPTR	;Send to terminal and return
;
;SETUP subroutine: Request HEX address input from terminal
SETUP			JSR	CHROUT	;Send command keystroke to terminal
					JSR	SPC	;Send [SPACE] to terminal
					BRA	HEXIN4	;Request a 0-4 digit HEX address input from terminal
;
;HEX input subroutines:
;Request 1 to 4 ASCII HEX digits from terminal, then convert digits into a binary value
;HEXIN2 - returns value in A reg and Y reg only (Y reg always $00)
;HEXIN4 - returns values in A reg, Y reg and INDEXL/INDEXH
;For 1 to 4 digits entered, HEXDATAH and HEXDATAL contain the output
;Variable BUFIDX will contain the number of digits entered
;HEX2 - Prints MSG# in A reg then calls HEXIN2
;HEX4 - Prints MSG# in A reg then calls HEXIN4
;
HEX4			JSR	PROMPT	;Print MSG # from A reg
HEXIN4		LDX	#$04	;Set for number of characters allowed
					JSR	HEXINPUT	;Convert digits
					STY	INDEXH	;Store to INDEXH
					STA	INDEXL	;Store to INDEXL
					RTS	;Return to caller
;
HEX2			JSR	PROMPT	;Print MSG # from A reg
HEXIN2		LDX	#$02	;Set for number of characters allowed
;
;HEXINPUT subroutine: request 1 to 4 HEX digits from terminal,
;then convert ASCII HEX to HEX
;Setup RDLINE subroutine parameters:
HEXINPUT	JSR	DOLLAR	;Send "$" to console
					JSR	RDLINE	;Request ASCII HEX input from terminal
					BEQ	HINEXIT	;Exit if none (Z flag already set)
					STZ	HEXDATAH	;Clear Upper HEX byte
					STZ	HEXDATAL	;Clear Lower HEX byte
					LDY	#$02	;Set index for 2 bytes
ASCLOOP		PHY	;Save it to stack
					LDA	INBUFF-1,X	;Read ASCII digit from buffer
					TAY	;Xfer to Y Reg (LSD)
					DEX	;Decrement input count
					BEQ	NO_UPNB	;Branch if no upper nibble
					LDA	INBUFF-1,X	;Read ASCII digit from buffer
					BRA	DO_UPNB	;Branch to include upper nibble
NO_UPNB		LDA	#$30	;Load ASCII "0" (MSD)
DO_UPNB		JSR	ASC2BIN	;Convert ASCII digits to binary value
					PLY	;Get index from stack
					STA	HEXDATAH-1,Y	;Write byte to indexed HEX input buffer location
					CPX	#$00	;Any more digits?
					BEQ	HINDONE	;If not, exit
					DEY	;Else, decrement to next byte set
					DEX	;Decrement index count
					BNE	ASCLOOP	;Loop back for next byte
HINDONE		LDY	HEXDATAH	;Get High Byte
					LDA	HEXDATAL	;Get Low Byte
					LDX	BUFIDX	;Get input count (Z flag)
HINEXIT		RTS	;And return to caller
;
;Routines to update pointers for memory operations
;
;UPD_STL subroutine: Increments Source and Target pointers
;UPD_TL subroutine: Increments Target pointers only
; then drops into decrement length pointer. Used by multiple commands
UPD_STL		INC	SRCL	;Increment source low byte
					BNE	UPD_TL	;Check for rollover
					INC	SRCH	;Increment source high byte
UPD_TL		INC	TGTL	;Increment target low byte
					BNE	DECLEN	;Check for rollover
					INC	TGTH	;Increment target high byte
;
;DECLEN subroutine: decrement 16-bit variable LENL/LENH
DECLEN		LDA	LENL	;Get length low byte
					BNE	SKP_LENH	;Test for LENL = zero
					DEC	LENH	;Else decrement length high byte
SKP_LENH	DEC	LENL	;Decrement length low byte
					RTS	;Return to caller
;
;DECINDEX subroutine: decrement 16 bit variable INDEXL/INDEXH
DECINDEX	LDA	INDEXL	;Get index low byte
					BNE	SKP_IDXH	;Test for INDEXL = zero
					DEC	INDEXH	;Decrement index high byte
SKP_IDXH	DEC	INDEXL	;Decrement index low byte
					RTS	;Return to caller
;
;INCINDEX subroutine: increment 16 bit variable INDEXL/INDEXH
INCINDEX	INC	INDEXL	;Increment index low byte
					BNE	SKP_IDX	;If not zero, skip high byte
					INC	INDEXH	;Increment index high byte
SKP_IDX		RTS	;Return to caller
;
;Output routines for formatting, backspaces, CR/LF, BEEP, etc.
; all routines preserve the A reg on exit.
;
;BEEP subroutine: Send ASCII [BELL] to terminal
BEEP			PHA	;Save A reg on Stack
					LDA	#$07	;Get ASCII [BELL] to terminal
					BRA	SENDIT	;Branch to send
;
;BSOUT subroutine: send a Backspace to terminal
BSOUT			JSR	BSOUT2	;Send an ASCII backspace
					JSR	SPC	;Send space to clear out character
BSOUT2		PHA	;Save character in A reg
					LDA	#$08	;Send another Backspace to return
BRCHOUT		BRA	SENDIT	;Branch to send
;
BSOUT3T		JSR	BSOUT2	;Send a Backspace 3 times
BSOUT2T		JSR	BSOUT2	;Send a Backspace 2 times
					BRA	BSOUT2	;Send a Backspace and return
;
;SPC subroutines: Send a Space to terminal 1,2 or 4 times
SPC4			JSR	SPC2	;Send 4 Spaces to terminal
SPC2			JSR	SPC	;Send 2 Spaces to terminal
SPC				PHA	;Save character in A reg
					LDA	#$20	;Get ASCII Space
					BRA	SENDIT	;Branch to send
;
;DOLLAR subroutine: Send "$" to terminal
DOLLAR		PHA	;Save A reg on STACK
					LDA	#$24	;Get ASCII "$"
					BRA	SENDIT	;Branch to send
;
;Send CR,LF to terminal
CR2				JSR	CROUT	;Send CR,LF to terminal
CROUT			PHA	;Save A reg
					LDA	#$0D	;Get ASCII Return
					JSR	CHROUT	;Send to terminal
					LDA	#$0A	;Get ASCII Linefeed
SENDIT		JSR	CHROUT	;Send to terminal
					PLA	;Restore A reg
					RTS	;Return to caller
;
;GLINE subroutine: Send a horizontal line to terminal
; used by memory display only, does not preserve any registers
;
GLINE			LDX	#$4F	;Load index for 79 decimal
					LDA	#$7E	;Get "~" character
GLINEL		JSR	CHROUT	;Send to terminal (draw a line)
					DEX	;Decrement count
					BNE	GLINEL	;Branch back until done
					RTS	;Return to caller
;
;Routines to output 8/16-bit Binary Data and Ascii characters
;
;PRASC subroutine: Print A-reg as ASCII, else print "."
;Printable ASCII byte values = $20 through $7E
PRASC			CMP	#$7F	;Check for first 128
					BCS	PERIOD	;If = or higher, branch
					CMP	#$20	;Check for control characters
					BCS	ASCOUT	;If space or higher, branch and print
PERIOD		LDA	#$2E	;Else, print a "."
ASCOUT		JMP	CHROUT	;Send byte in A-Reg, then return
;
;PRBYTE subroutine:
; Converts a single Byte to 2 HEX ASCII characters and sends to console
; on entry, A reg contains the Byte to convert/send
; Register contents are preserved on entry/exit
PRBYTE		PHA	;Save A register
					PHY	;Save Y register
PRBYT2		JSR	BIN2ASC	;Convert A reg to 2 ASCII Hex characters
					JSR	CHROUT	;Print high nibble from A reg
					TYA	;Transfer low nibble to A reg
					JSR	CHROUT	;Print low nibble from A reg
					PLY	;Restore Y Register
					PLA	;Restore A Register
					RTS	;And return to caller
;
;PRINDEX	subroutine:
; Used by Memory Dump and Text Entry routines
; Prints a $ sign followed by the current value of INDEXH/L
PRINDEX		JSR	DOLLAR	;Print a $ sign
					LDA	INDEXH	;Get Index high byte
					LDY	INDEXL	;Get Index low byte
;
;PRWORD	subroutine:
;	Converts a 16-bit word to 4 HEX ASCII characters and sends to console
; on entry, A reg contains High Byte, Y reg contains Low Byte
; Register contents are preserved on entry/exit
PRWORD		PHA	;Save A register
					PHY	;Save Y register
					JSR	PRBYTE	;Convert and print one HEX character (00-FF)
					TYA	;Get Low byte value
					BRA	PRBYT2	;Finish up Low Byte and exit
;
;RDLINE subroutine: Store keystrokes in buffer until [RETURN] key it struck
;Used only for Hex entry, so only (0-9,A-F) are accepted entries
;Lower-case alpha characters are converted to upper-case.
;On entry, X reg = buffer length. On exit, X reg = buffer count
;[BACKSPACE] key removes keystrokes from buffer.
;[ESCAPE] key aborts then re-enters monitor. 
RDLINE		STX	BUFLEN	;Store buffer length   
					STZ	BUFIDX	;Zero buffer index
RDLOOP		JSR	RDCHAR	;Get character from terminal, convert LC2UC
					CMP	#$1B	;Check for ESC key
					BEQ	RDNULL	;If yes, exit back to Monitor
NOTESC		CMP	#$0D	;Check for C/R
					BEQ	EXITRD	;Exit if yes
					CMP	#$08	;Check for Backspace
					BEQ	RDBKSP	;If yes handle backspace
TSTHEX		CMP	#$30	;Check for '0' or higher
					BCC	INPERR	;Branch to error if less than '0'
					CMP	#$47	;Check for 'G' ('F'+1)
					BCS	INPERR	;Branch to error if 'G' or higher
FULTST		LDX	BUFIDX	;Get the current buffer index
					CPX	BUFLEN	;Compare to length for space
					BCC	STRCHR	;Branch to store in buffer
INPERR		JSR	BEEP	;Else, error, send Bell to terminal
					BRA	RDLOOP	;Branch back to RDLOOP
STRCHR		STA	INBUFF,X	;Store keystroke in buffer
					JSR	CHROUT	;Send keystroke to terminal
					INC	BUFIDX	;Increment buffer index
					BRA	RDLOOP	;Branch back to RDLOOP
RDBKSP		LDA	BUFIDX	;Check if buffer is empty
					BEQ	INPERR	;Branch if yes
					DEC	BUFIDX	;Else, decrement buffer index
					JSR	BSOUT	;Send Backspace to terminal
					BRA	RDLOOP	;Loop back and continue
EXITRD		LDX	BUFIDX	;Get keystroke count (Z flag)
					BNE	AOK	;If data entered, normal exit
					BBS7	CMDFLAG,AOK	;Branch if CMD flag active
RDNULL		JMP	(WRMMNVEC0)	;Quit to Monitor warm start
;
;RDCHAR subroutine: Waits for a keystroke to be entered.
; if keystroke is a lower-case alphabetical, convert it to upper-case
RDCHAR		JSR	CHRIN	;Request keystroke input from terminal
					CMP	#$61	;Check for lower case value range
					BCC	AOK	;Branch if < $61, control code/upper-case/numeric
					SBC	#$20	;Subtract $20 to convert to upper case
AOK				RTS	;Character received, return to caller
;
;Continue routine, called by commands to confirm execution
;when No is confirmed, return address removed from stack
;and the exit goes back to the monitor loop.
;Short version prompts for (Y/N) only.
CONTINUE	LDA	#$00	;Get msg "cont? (Y/N)" to terminal
					BRA	SH_CONT	;Branch down
CONTINUE2	LDA	#$01	;Get short msg "(Y/N)" only
SH_CONT		JSR	PROMPT	;Send to terminal
TRY_AGN		JSR	RDCHAR	;Get keystroke from terminal
					CMP	#$59	;"Y" key?
					BEQ	DOCONT	;if yes, continue/exit
					CMP	#$4E	;if "N", quit/exit
					BEQ	DONTCNT	;Return if not ESC
					JSR	BEEP	;Send Beep to console
					BRA	TRY_AGN	;Loop back, try again
DONTCNT		PLA	;Else remove return address
					PLA	;discard it,
DOCONT		RTS	;Return
;
;******************************
;* Monitor command processors *
;******************************
;
;[,] Delay Setup Routine
;	This routine gets hex input via the console
;	- first is a hex byte ($00-$FF) for the millisecond count
;	- second is a hex word ($0000-$FFFF) for the delay multiplier
;		these are stored in variables SETIM, DELLO/DELHI
;
SET_DELAY	LDA	#$17	;Get millisecond delay message
					JSR	HEX2	;Use short cut version for print and input
					STA	SETIM	;Else store millisecond count in variable
GETMULT		LDA	#$18	;Get Multiplier message
					JSR	HEX4	;Use short cut version for print and input
					STA	DELLO	;Store Low byte
					STY	DELHI	;Store High byte
					RTS	;Return to caller
;
;[\] Execute XL Delay
; Get an 8-bit value for extra long delay, execute is entered
SET_XLDLY	LDA	#$19	;Get XL Loop message
					JSR	HEX2	;Use short cut version for print and input
					STA	XDL	;Save delay value
					LDA	#$0D	;Get ASCII C/R
					JSR	CHROUT	;Send C/R (shows delay has been executed, no L/F)
					JMP	EXE_XLDLY	;Execute Extra Long delay loop
;
;[(] INIMACRO command: Initialize keystroke input buffer
;initializes buffer head/tail pointers and resets buffer count to zero
;input buffer appears empty so command macro starts at the head of the buffer
INIMACRO	STZ	LPCNTL	;Zero Loop count low byte
					STZ	LPCNTH	;Zero Loop count high byte
					STZ	LPCNTF	;Zero Loop count flag
;
LP_CNT_FL	LDA	#$2D	;Get Loop Count msg
					JSR	PROMPT	;send to console
					LDA	#$01	;Get short msg "(Y/N)" only
					JSR	PROMPT	;Send to terminal
					JSR	RDCHAR	;Get keystroke from terminal
					CMP	#$59	;"Y" key?
					BEQ	DOLOOPS	;if yes, set loop flag
					CMP	#$4E	;if "N", quit/exit
					BEQ	NOLOOPS	;if no, don't set loop flag
					JSR	BEEP	;Neither y/n selected, sound bell
					BRA	LP_CNT_FL	;Branch back, try again
;
DOLOOPS		SMB7	LPCNTF	;Set high order bit of Loop flag
NOLOOPS		STZ	ICNT	;Zero Input buffer count
					STZ	ITAIL	;Zero Input buffer tail pointer
MACINI		STZ	IHEAD	;Zero Input buffer head pointer
DONEFILL	RTS	;Return to caller
;
;[)] RUNMACRO command: Run monitor command macro. This will indicate that there
;are 128 keystrokes in the keystroke input buffer. The monitor will process these
;as if they were received from the terminal (typed-in by the user). Because the
;last keystroke stored in the keystroke buffer was ")", this will loop continuously
;Use [BREAK] to exit macro
RUNMACRO	LDA	#$7F	;Set keystroke buffer tail pointer to $7F
					STA	ITAIL	;Push tail pointer to end
					INC	A	;Increment to $80 for buffer count (full)
					STA	ICNT	;Make count show as full
					BBR7	LPCNTF,NOLP_CNT	;If Loop flag clear, branch around it
					INC	LPCNTL	;Increment loops low byte
					BNE	SKP_LPC	;If not zero, skip high byte
					INC	LPCNTH	;Increment loops high byte
SKP_LPC		LDA	#$2E	;Get Loops msg
					JSR	PROMPT	;Send to console
					LDA	LPCNTL	;Get Loop count low
					LDY	LPCNTH	;Get Loop count high
					JSR	HEX2ASC	;Print Loop count
					JSR	CROUT	;Send C/R to console
NOLP_CNT	BRA	MACINI	;Zero Head pointer and exit
;
;[C] Compare one memory range to another and display any addresses which do not match
;[M] Move routine uses this section for parameter input, then branches to MOVER below
;[F] Fill routine uses this section for parameter input but requires a fill byte value
;[CTRL-P] Program EEPROM uses this section for parameter input and to write the EEPROM
;Uses source, target and length input parameters. errors in compare are shown in target space
;
FM_INPUT	LDA	#$05	;Send "val: " to terminal
					JSR	HEX2	;Use short cut version for print and input
					TAX	;Xfer fill byte to X reg
					JSR	CONTINUE	;Handle continue prompt
;
;Memory fill routine: parameter gathered below with Move/Fill, then a jump to here
;Xreg contains fill byte value
FILL_LP		LDA	LENL	;Get length low byte
					ORA	LENH	;OR in length high byte
					BEQ	DONEFILL	;Exit if zero
					TXA	;Get fill byte
					STA	(TGTL)	;Store in target location
					JSR	UPD_TL	;Update Target/Length pointers
					BRA	FILL_LP	;Loop back until done
;
;Compare/Move/Fill memory operations enter here, branches as required
;
CPMVFL		STA	TEMP2	;Save command character
					JSR	CHROUT	;Print command character (C/M/F)
					CMP	#$46	;Check for F - fill memory
					BNE	PRGE_E	;If not continue normal parameter input
					LDA	#$03	;Get msg " addr:"
					BRA	F_INPUT	;Branch to handle parameter input
;
;EEPROM wrte operation enters here
;
PROGEE		LDA	#$21	;Get PRG_EE msg
					JSR	PROMPT	;send to terminal
					STZ	TEMP2	;Clear (Compare/Fill/Move) / error flag
;
PRGE_E		LDA	#$06	;Send " src:" to terminal
					JSR	HEX4	;Use short cut version for print and input
					STA	SRCL	;Else, store source address in variable SRCL,SRCH
					STY	SRCH	;Store high address
					LDA	#$07	;Send " tgt:" to terminal
F_INPUT		JSR	HEX4	;Use short cut version for print and input
					STA	TGTL	;Else, store target address in variable TGTL,TGTH
					STY	TGTH	;Store high address
					LDA	#$04	;Send " len:" to terminal
					JSR	HEX4	;Use short cut version for print and input
					STA	LENL	;ELSE, store length address in variable LENL,LENH
					STY	LENH	;Store high address
;
; All input parameters for Source, Target and Length entered
					LDA	TEMP2	;Get Command character
					CMP	#$46	;Check for fill memory
					BEQ	FM_INPUT	;Handle the remaining input
					CMP	#$43	;Test for Compare
					BEQ	COMPLP	;Branch if yes
					CMP	#$4D	;Check for Move
					BEQ	MOVER	;Branch if yes
;
PROG_EE		LDA	#$22	;Get warning msg
					JSR	PROMPT	;Send to console
					JSR	CONTINUE2	;Prompt for y/n
;
;Programming of the EEPROM is now confirmed by user
; This routine will copy the core move and test routine
; from ROM to RAM, then call COMPLP to write and compare
; as I/O can generate interrupts which point to ROM routines,
; all interrupts must be disabled during the sequence.
;
;Send message to console for writing EEPROM
					LDA	#$23	;Get write message
					JSR	PROMPT	;Send to console
OC_LOOP		LDA	OCNT	;Check output buffer count
					BNE	OC_LOOP	;Loop back until buffer sent
;
;Xfer byte write code to RAM for execution
					LDX	#BYTE_WRE-BYTE_WRS+1	;Get length of byte write code
BYTE_XFER	LDA	BYTE_WRS-1,X	;Get code
					STA	<(BURN_BYTE-1),X	;Write code to RAM
					DEX	;Decrement index
					BNE	BYTE_XFER	;Loop back until done
;
PROG_EEP	SMB7	TEMP2	;Set EEPROM write active mask
					JSR	COMPLP	;Call routine to write/compare
					BBR6	TEMP2,PRG_GOOD	;Skip down if no error
					LDA	#$25	;Get Prog failed message
					BRA	BRA_PRMPT	;Branch to Prompt routine
;
PRG_GOOD	LDA	#$24	;Get completed message
					JSR	PROMPT	;Send to console
					LDA	#$26	;Get warning message for RTC and Reset
BRA_PRMPT	JMP	PROMPT	;Send to console and exit
;
COMPLP		LDA	LENL	;Get low byte of length
					ORA	LENH	;OR in High byte of length
					BEQ	QUITMV	;If zero, nothing to compare/write
					BBR7	TEMP2,SKP_BURN	;Skip burn if bit 7 clear
					JSR	BURN_BYTE	;Else Burn a byte to EEPROM
SKP_BURN	LDA	(SRCL)	;Else load source
					CMP	(TGTL)	;Compare to source
					BEQ	CMP_OK	;If compare is good, continue
;
					SMB6	TEMP2	;Set bit 6 of TEMP2 flag (compare error)
					JSR	SPC2	;Send 2 spaces
					JSR	DOLLAR	;Print $ sign
					LDA	TGTH	;Get high byte of address
					LDY	TGTL	;Get Low byte of address
					JSR	PRWORD	;Print word
					JSR	SPC	;Add 1 space for formatting
;
CMP_OK		JSR	UPD_STL	;Update pointers
					BRA	COMPLP	;Loop back until done
;
;Parameters for move memory entered and validated
; now make decision on which direction to do the actual move
; if overlapping, move from end to start, else from start to end
MOVER			JSR	CONTINUE	;Prompt to continue move
					SEC	;Set carry flag for subtract
					LDA	TGTL	;Get target lo byte
					SBC	SRCL	;Subtract source lo byte
					TAX	;Move to X reg temporarily
					LDA	TGTH	;Get target hi byte
					SBC	SRCH	;Subtract source hi byte
					TAY	;Move to Y reg temporarily
					TXA	;Xfer lo byte difference to A reg
					CMP	LENL	;Compare to lo byte length
					TYA	;Xfer hi byte difference to A reg
					SBC	LENH	;Subtract length lo byte
					BCC	RIGHT	;If carry is clear, overwrite condition exists
;Move memory block first byte to last byte, no overlap condition
MVNO_LP		LDA	LENL	;Get length low byte
					ORA	LENH	;OR in length high byte
					BEQ	QUITMV	;Exit if zero bytes to move
					LDA	(SRCL)	;Load source data
					STA	(TGTL)	;Store as target data
					JSR	UPD_STL	;Update Source/Target/Length variables
					BRA	MVNO_LP	;Branch back until length is zero
;
;Move memory block last byte to first byte
; avoids overwrite in source/target overlap
RIGHT			LDX	LENH	;Get the length hi byte count
					CLC	;Clear carry flag for add
					TXA	;Xfer High page to A reg
					ADC	SRCH	;Add in source hi byte
					STA	SRCH	;Store in source hi byte
					CLC	;Clear carry for add
					TXA	;Xfer High page to A reg 
					ADC	TGTH	;Add to target hi byte
					STA	TGTH	;Store to target hi byte
					INX	;Increment high page value for use below in loop
					LDY	LENL	;Get length lo byte
					BEQ	MVPG	;If zero no partial page to move
					DEY	;Else, decrement page byte index
					BEQ	MVPAG	;If zero, no pages to move
MVPRT			LDA	(SRCL),Y	;Load source data
					STA	(TGTL),Y	;Store to target data
					DEY	;Decrement index
					BNE  MVPRT	;Branch back until partial page moved
MVPAG			LDA	(SRCL),Y	;Load source data
					STA	(TGTL),Y	;Store to target data
MVPG			DEY	;Decrement page count
					DEC	SRCH	;Decrement source hi page
					DEC	TGTH	;Decrement target hi page
					DEX	;Decrement page count
					BNE	MVPRT	;Loop back until all pages moved
QUITMV		RTS	;Return to caller
;
BYTE_WRS	SEI	;Disable interrupts
					LDA	(SRCL)	;Get source byte
					STA	(TGTL)	;Write to target byte
					LDA	(TGTL)	;Read target byte (EEPROM)
					AND	#%01000000	;Mask off bit 6 - toggle bit
BYTE_WLP	STA	TEMP3	;Store in Temp location
					LDA	(TGTL)	;Read target byte again (EEPROM)
					AND	#%01000000	;Mask off bit 6 - toggle bit
					CMP	TEMP3	;Compare to last read (toggles if write mode)
					BNE	BYTE_WLP	;Branch back if not done
					CLI	;Re-enable interrupts
BYTE_WRE	RTS	;Return to caller
;
;[D] HEX/TEXT DUMP command:
; Display in HEX followed by TEXT the contents of 256 consecutive memory addresses
MDUMP			SMB7	CMDFLAG	;Set Command flag
					JSR	SETUP	;Request HEX address input from terminal
					BNE	LINED	;Branch if new address entered (Z flag set already)
					LDA	TEMP1L	;Else, point to next consecutive memory page
					STA	INDEXL	;address saved during last memory dump
					LDA	TEMP1H	;xfer high byte of address
					STA	INDEXH	;save in pointer
LINED			JSR	DMPGR	;Send address offsets to terminal 
					JSR	GLINE	;Send horizontal line to terminal
					JSR	CROUT	;Send CR,LF to terminal
					LDX	#$10	;Set line count for 16 rows
DLINE			JSR	SPC4	;Send 4 Spaces to terminal
					JSR	PRINDEX	;Print INDEX value
					JSR	SPC2	;Send 2 Spaces to terminal
					LDY	#$00	;Initialize line byte counter
GETBYT		LDA	(INDEXL),Y	;Read indexed byte
					JSR	PRBYTE	;Display byte as a HEX value
					JSR	SPC	;Send Space to terminal
					INY	;Increment index
					CPY	#$10	;Check for all 16
					BNE	GETBYT	;loop back until 16 bytes have been displayed
					JSR	SPC	;Send a space
GETBYT2		LDA	(INDEXL)	;Read indexed byte
					JSR	PRASC	;Print ASCII character
					JSR	INCINDEX	;Increment index
					DEY	;Decrement count (from 16)
					BNE	GETBYT2	;loop back until 16 bytes have been displayed					
					JSR	CROUT	;else, send CR,LF to terminal
					LDA	INDEXL	;Get current index low
					STA	TEMP1L	;Save to temp1 low
					LDA	INDEXH	;Get current index high
					STA	TEMP1H	;Save to temp1 high
					DEX	;Decrement line count
					BNE	DLINE	;Branch back until all 16 done
					JSR	GLINE	;Send horizontal line to terminal
;DMPGR subroutine: Send address offsets to terminal
DMPGR			LDA	#$02	;Get msg for "addr:" to terminal
					JSR	PROMPT	;Send to terminal
					JSR	SPC2	;Add two additional spaces
					LDX	#$00	;Zero index count
MDLOOP		TXA	;Send "00" thru "0F", separated by 1 Space, to terminal
					JSR	PRBYTE	;Print byte value
					JSR	SPC	;Add a space
					INX	;Increment the count
					CPX	#$10	;Check for 16
					BNE	MDLOOP	;Loop back until done
;	Print the ASCII text header "0123456789ABCDEF"
					JSR	SPC	;Send a space
					LDX	#$00	;Zero X reg for "0"
MTLOOP		TXA	;Xfer to A reg
					JSR	BIN2ASC	;Convert Byte to two ASCII digits
					TYA	;Xfer the low nibble character to A reg
					JSR	CHROUT	;Send least significant HEX to terminal
					INX	;Increment to next HEX character
					CPX	#$10	;Check for 16
					BNE	MTLOOP	;branch back till done
					JMP	CROUT	;Do a CR/LF and return
;
;[E] Examine/Edit command: Display in HEX then change the contents of a specified memory address
CHANGE		JSR	SETUP	;Request HEX address input from terminal
CHNG_LP		JSR	SPC2	;Send 2 spaces
					LDA	(INDEXL)	;Read specified address
					JSR	PRBYTE	;Display HEX value read
					JSR	BSOUT3T ;Send 3 Backspaces
					JSR	HEXIN2	;Get input, result in A reg
					STA	(INDEXL)	;Save entered value at Index pointer
					CMP	(INDEXL)	;Compare to ensure a match
					BEQ	CHOK	;Branch if compare is good
					LDA	#$3F	;Get "?" for bad compare
					JSR	CHROUT	;Send to terminal
CHOK			JSR	INCINDEX	;Increment Index
					BRA	CHNG_LP	;Loop to continue command
;
;[G] GO command: Begin executing program code at a specified address
;Prompts the user for a start address, places it in COMLO/COMHI
;If no address entered, uses default address at COMLO/COMHI
;Loads the A,X,Y,P registers from presets and does a JSR to the routine
;Upon return, registers are saved back to presets for display later
;Also saves the stack pointer and status register upon return
;Stack pointer is not changed due to constant IRQ service routines
GO				SMB7	CMDFLAG	;Set Command flag
					JSR	SETUP	;Get HEX address (A/Y regs hold 16-bit value)
					BEQ	EXEC_GO	;If not, setup registers and execute (Z flag set already)
					STA	COMLO	;Save entered address to pointer low byte
					STY	COMHI	;Save entered address to pointer hi byte
;Preload all 65C02 MPU registers from monitor's preset/result variables
EXEC_GO		LDA	PREG	;Load processor status register preset
					PHA	;Push it to the stack
					LDA	AREG	;Load A-Reg preset
					LDX	XREG	;Load X-Reg preset
					LDY	YREG	;Load Y-Reg preset
					PLP	;Pull the processor status register
;Call user program code as a subroutine
					JSR	DOCOM	;Execute code at specified address
;Store all 65C02 MPU registers to monitor's preset/result variables: store results
					PHP	;Save the processor status register to the stack
					STA	AREG	;Store A-Reg result
					STX	XREG	;Store X-Reg result
					STY	YREG	;Store Y-Reg result
					PLA	;Get the processor status register
					STA	PREG	;Store the result
					TSX	;Xfer stack pointer to X-reg
					STX	SREG	;Store the result
					CLD	;Clear BCD mode in case of sloppy user code ;-)
TXT_EXT		RTS	;Return to caller
DOCOM			JMP	(COMLO)	;Execute the command
;
;[T] LOCATE TEXT STRING command: search memory for an entered text string
;Memory range scanned is $0800 through $FFFF (specified in SENGINE subroutine)
;SRCHTXT subroutine: request 1 - 16 character text string from terminal, followed by Return
;[ESCAPE] aborts, [BACKSPACE] erases last keystroke. String will be stored in SRCHBUFF
SRCHTXT		LDA	#$08	;Get msg " find text:"
					JSR	PROMPT	;Send to terminal
					LDX	#$00	;Initialize index/byte counter
STLOOP		JSR	CHRIN	;Get input from terminal
					CMP	#$0D	;Check for C/R
					BEQ	SRCHRDY	;Branch to search engine
					CMP	#$1B	;Check for ESC
					BEQ	TXT_EXT	;Exit to borrowed RTS
					CMP	#$08	;Check for B/S
					BNE	STBRA	;If not, store character into buffer
					TXA	;Xfer count to A reg
					BEQ	STLOOP	;Branch to input if zero
					JSR	BSOUT	;Else, send B/S to terminal
					DEX	;Decrement index/byte counter
					BRA	STLOOP	;Branch back and continue
STBRA			STA	SRCHBUFF,X	;Store character in buffer location
					JSR	CHROUT	;Send character to terminal
					INX	;Increment counter
					CPX	#$10	;Check count for 16
					BNE	STLOOP	;Loop back for another character
					BRA	SRCHRDY	;Branch to search engine
;
;[H] LOCATE BYTE STRING command: search memory for an entered byte string
;Memory range scanned is $0800 through $FFFF (specified in SENGINE subroutine)
;SRCHBYT subroutine: request 0 - 16 byte string from terminal, each byte followed by Return
;[ESCAPE] aborts. HEX data will be stored in SRCHBUFF
SRCHBYT		SMB7	CMDFLAG	;Set Command flag
					LDA	#$09	;Get msg " find bin:"
					JSR	PROMPT	;Send to terminal
					LDX	#$00	;Initialize index
SBLOOP		PHX	;Save index on stack
					JSR	HEXIN2	;Request HEX byte
					JSR	SPC	;Send space to terminal
					PLX	;Restore index from stack
					LDY	BUFIDX	;Get # of characters entered 
					BEQ	SRCHRDY ;Branch if no characters
					STA	SRCHBUFF,X ;Else, store in buffer
					INX	;Increment index
					CPX	#$10	;Check for 16 (max)
					BNE	SBLOOP	;Loop back until done/full
SRCHRDY		STX	IDX	;Save input character count
					CPX	#$00	;Check buffer count
					BEQ	TXT_EXT	;Exit if no bytes in buffer
					LDA	#$0C	;Else, get msg "Searching.."
					JSR	PROMPT	;Send to terminal
;
;SENGINE subroutine: Scan memory range $0800 through $FFFF for exact match to string
;contained in buffer SRCHBUFF (1 to 16 bytes/characters). Display address of first
;byte/character of each match found until the end of memory is reached.
SENGINE		LDA	#$08	;Initialize address to $0800: skip over $0000 through $07FF
					STA	INDEXH	;Store high byte
					STZ	INDEXL ;Zero low byte
SENGBR2		LDX	#$00	;Initialize buffer index
SENGBR3		LDA	(INDEXL)	;Read current memory location
					CMP	SRCHBUFF,X	;Compare to search buffer
					BEQ	SENGBR1	;Branch for a match
					JSR	SINCPTR	;Increment pointer, test for end of memory
					BRA	SENGBR2	;Loop back to continue
SENGBR1		JSR	SINCPTR	;Increment pointer, test for end of memory
					INX	;Increment buffer index
					CPX	IDX	;Compare buffer index to address index
					BNE	SENGBR3	;Loop back until done
					SEC	;Subtract buffer index from memory pointer; Set carry
					LDA	INDEXL	;Get current address for match lo byte
					SBC	IDX	;Subtract from buffer index
					STA	INDEXL	;Save it back to lo address pointer
					LDA	INDEXH	;Get current address for match hi byte
					SBC	#$00	;Subtract carry flag
					STA	INDEXH	;Save it back to hi address pointer
					LDA	#$0B	;Get msg "found"
					JSR	PROMPT	;Send to terminal
					LDA	#':'	;Get Ascii colon
					JSR	CHROUT	;Send to console
					JSR	PRINDEX	;Print Index address
					LDA	#$0D	;Get msg "(n)ext? "
					JSR	PROMPT	;Send to terminal
					JSR	RDCHAR	;Get input from terminal
					CMP	#$4E	;Check for "(n)ext"
					BNE	NCAREG	;Exit if not requesting next
					JSR	SINCPTR	;Increment address pointer, test for end of memory
					BRA	SENGBR2	;Branch back and continue till done
;
;Increment memory address pointer. If pointer high byte = 00 (end of searchable ROM memory),
;send "not found" to terminal then return to monitor 
SINCPTR		JSR	INCINDEX	;Increment Index pointer
					LDA	INDEXH	;Check for wrap to $0000
					BNE	NCAREG	;If not, return
					PLA	;Else, Pull return address from stack
					PLA	;and exit with msg
					LDA	#$0A	;Get msg "not found"
					JMP	PROMPT	;Send msg to terminal and exit
;
;[P] Processor Status command: Display then change PS preset/result
PRG				LDA	#$0E	;Get MSG # for Processor Status register
					BRA	REG_UPT	;Finish register update
;
;[S] Stack Pointer command: Display then change SP preset/result
SRG				LDA	#$0F	;Get MSG # for Stack register
					BRA	REG_UPT	;Finish Register update
;
;[Y] Y-Register command: Display then change Y-reg preset/result
YRG				LDA	#$10	;Get MSG # for Y Reg
					BRA	REG_UPT	;Finish register update
;
;[X] X-Register command: Display then change X-reg preset/result
XRG				LDA	#$11	;Get MSG # for X Reg
					BRA	REG_UPT	;Finish register update
;
;[A] A-Register command: Display then change A-reg preset/result
ARG				LDA	#$12	;Get MSG # for A reg
;
REG_UPT		PHA	;Save MSG # to stack
					TAX	;Xfer to X reg
					JSR	PROMPT	;Print Register message
					LDA	PREG-$0E,X	;Read Register (A,X,Y,S,P) preset/result
					JSR	PRBYTE	;Display HEX value of register
					JSR	SPC	;Send [SPACE] to terminal
					JSR	HEXIN2	;Get up to 2 HEX characters
					PLX	;Get MSG # from stack
					STA	PREG-$0E,X	;Write register (A,X,Y,S,P) preset/result
NCAREG		RTS	;Return to caller
;
;[R] REGISTERS command: Display contents of all preset/result memory locations
PRSTAT		JSR	CHROUT	;Send "R" to terminal
PRSTAT1		LDA	#$13	;Get Header msg
					JSR	PROMPT	;Send to terminal
					LDA	PCH	;Get PC high byte
					LDY	PCL	;Get PC low byte
					JSR	PRWORD	;Print 16-bit word
					JSR	SPC	;Send 1 space
;
					LDX	#$04	;Set for count of 4
REGPLOOP	LDA	PREG,X	;Start with A reg variable
					JSR	PRBYTE	;Print it
					JSR	SPC	;Send 1 space
					DEX	;Decrement count
					BNE	REGPLOOP	;Loop back till all 4 are sent
;
					LDA	PREG	;Get Status register preset
					LDX	#$08	;Get the index count for 8 bits
SREG_LP		ASL	A	;Shift bit into Carry
					PHA	;Save current (shifted) SR value
					LDA	#$30	;Load an Ascii zero
					ADC	#$00	;Add zero (with Carry)
					JSR	CHROUT	;Print bit value (0 or 1)
					PLA	;Get current (shifted) SR value
					DEX	;Decrement bit count
					BNE	SREG_LP	;Loop back until all 8 printed
					JMP	CROUT	;Send CR/LF and return
;
;[I] command: TEXT ENTRY enter ASCII text beginning at a specified address
TEXT			JSR	SETUP	;Send "I" command, handle setup
EDJMP1		JSR	CROUT	;Send CR,LF to terminal
					STA	TEMP2L	;Save current edit address
					STY	TEMP2H	;Save high byte
EDJMP2		JSR	CHRIN	;Request a keystroke from terminal
					CMP	#$1B	;Check for end text entry
					BEQ	EDITDUN	;Branch and close out if yes
					CMP	#$0D	;Else, check for Return key
					BNE	ENOTRET	;Branch if not
					STA	(INDEXL)	;Save CR to current Index pointer
					JSR	INCINDEX	;Increment edit memory address pointer
					LDA	#$0A	;Get a LF character
					STA	(INDEXL)	;Store it in memory
					JSR	INCINDEX	;Increment edit memory address pointer
					LDA	INDEXL	;Get Start of next line
					LDY	INDEXH	;and the high byte
					BRA	EDJMP1	;Loop back to continue 
ENOTRET		CMP	#$08	;Check for backspace character
					BEQ	EDBKSPC	;Branch if yes
					STA	(INDEXL)	;Else, save to current Index pointer
					JSR	CHROUT	;Send keystroke to terminal
					JSR	INCINDEX	;Increment edit memory address pointer
					BRA	EDJMP2	;Loop back to EDJMP2
;Handle Backspace, don't allow past starting address
EDBKSPC		LDA	INDEXL	;Get current index low byte
					CMP	TEMP2L	;Compare to initial start address
					BNE	EDDOBKS	;if not equal, perform backspace
					LDA	INDEXH	;Get current index high byte
					CMP	TEMP2H	;Compare to initial start address
					BEQ	EDJMP2	;If same, branch to input loop
EDDOBKS		JSR	BSOUT	;Send backspace to terminal
					JSR	DECINDEX	;Decrement edit memory address pointer
					LDA	#$00	;Get a null character
					STA	(INDEXL)	;Store in place of character
					BRA	EDJMP2	;LOOP back to EDJMP2
EDITDUN		JSR	CR2	;Send 2 CR,LF to terminal
					JMP	PRINDEX	;Print INDEX value
;
;[CTRL-B] Start Enhanced Basic:
EHBASIC		LDA	#$2F	;Get EhBasic intro Msg
					JSR	PROMPT	;Send to terminal
;
EHB_TRY2	JSR	RDCHAR	;Get character (LC2UC)
					CMP	#'C'	;Check for Cold start
					BEQ	EHB_COLD	;If yes, go Cold Start
					CMP	#'W'	;Check for Warm start
					BEQ	EHB_WARM	;If yes. go Warm start
					JSR	BEEP	;Else, beep for entry error
					BRA	EHB_TRY2	;Branch back and try again
;
EHB_COLD	JMP	$B000	;Cold start ROM vector
;
EHB_WARM	JMP	$0000	;Warm start soft vector
;
;[CTRL-D]	Disassembler
DSSMBLR		LDA	#$2B	;Intro Message
					JSR	PROMPT	;Send to terminal
					LDA	#$03	;Msg 03 -" addr:"
					JSR	HEX4	;Print msg and get address
					JSR	CROUT	;Send CR,LF to terminal
RPT_LST		LDX	#$16	;Set list count to 22
DIS_LOOP	PHX	;Push count to stack
					JSR	DIS_LINE	;Disassemble 1 instruction
					PLX	;Pull count from stack
					DEX	;Decrement count
					BNE	DIS_LOOP	;Loop back till list count is zero
LST_LOOP	JSR	CHRIN	;Get input from terminal
					CMP	#$0D	;Check for Return key
					BEQ	EXT_LIST	;Exit if Return
					CMP	#$20	;Check for Space
					BNE	RPT_LST	;If not, go back and list another page
					JSR	DIS_LINE	;Else, Disassemble one line
					BRA	LST_LOOP	;Branch back and continue
;
;DISASSEMBLE LINE: disassemble 1 instruction from working address
DIS_LINE	JSR	PRINDEX	;Print working address
					JSR	SPC2	;Send 2 spaces to terminal
					LDA	(INDEXL)	;Read opcode from working memory pointer
					STA	OPCODE	;Save opcode
					JSR	PRB_SPC2	;Print byte, 2 spaces
					LSR	A	;Divide by 2 / shift low order bit into carry flag
					TAX	;Xfer Opcode /2 to X reg
					LDA	HDLR_IDX,X	;Get Pointer to handler table
					BCS	USE_RGHT	;If carry set use low nibble (odd)
					LSR	A	;Else shift upper nibble to lower nibble (even)
					LSR	A
					LSR	A
					LSR	A
USE_RGHT	AND	#$0F	;Mask off high nibble
					ASL	A	;Multiply by 2 for index
					TAX	;Use handler pointer to index handler table
					JSR	DODISL	;Call disassembler handler 
					JSR	CROUT	;Send CR,LF to terminal
					STZ	TEMP2	;Clear all flag bits
;
;INCNDX routine: increment working address pointer then read it
INCNDX		JSR	INCINDEX	;Increment working address pointer
					LDA	(INDEXL)	;Read from working memory address
EXT_LIST	RTS	;Done, return to caller/exit
;
DODISL		JMP	(HDLR_TAB,X)	;Execute address mode handler
;
;THREE BYTE routine: display operand bytes then mnemonic for three-byte instruction
;TWO BYTE routine: display operand byte then mnemonic for two-byte instruction
TRI_BYTE	SMB7	TEMP2	;Set Flag bit for 3-byte instruction
TWO_BYTE	JSR	GET_NEXT	;Read, display operand byte
					STA	CRCLO	;Save operand byte in CRCLO
					BBR7	TEMP2,TWO_BYTSPC	;Branch for 2-byte is clear
					JSR	GET_NEXT	;Read, display operand high byte
					STA	CRCHI	;Save operand high byte in CRCHI
					BRA	THREE_BYTSPC	;Send 2 spaces, send Mnemonic, return
;
;IMPLIED disassembler handler: single byte instructions: implied mode
;(note: ACC_MODE handler calls this)   
IMPLIED		JSR	SPC4	;Send 4 spaces
TWO_BYTSPC		JSR	SPC4	;Send 4 spaces
THREE_BYTSPC		JSR	SPC2	;Send 2 spaces
;
;PRT_MNEM subroutine: send 3 character mnemonic to terminal
; Mnemonic indexed by opcode byte. Sends "???" if byte is not a valid opcode
PRT_MNEM	LDY	OPCODE	;Get current Opcode as index
					LDX	MNE_PTAB,Y	;Get opcode pointer from table
					LDA	DIS_NMEM,X	;Get left byte
					STA	PTRL	;Store it to pointer
					LDA	DIS_NMEM+1,X	;Get right byte
					STA	PTRH	;Store it to pointer
					LDX	#$03	;Set count for 3 characters
NEXT_NME	LDA	#$00	;Zero A reg
					LDY	#$05	;Set count for 5 bits per character
LOOP_NME	ASL	PTRH	;Shift right byte into carry
					ROL	PTRL	;Rotate left byte byte into A reg
					ROL	A	;Rotate into A reg
					DEY	;Decrement bit count
					BNE	LOOP_NME	;Loop back till 5 bits in A reg
					ADC	#$3F	;Add $3F to convert to Ascii
					JSR	CHROUT	;Send the character to terminal
					DEX	;Decrement character count
					BNE	NEXT_NME	;Loop back till 3 characters sent
					BRA	BR_SPC2	;Send 2 spaces to terminal, return
;
;GET_NEXT subroutine: increment/read working address
; Display byte, send 2 spaces to terminal (displays operand byte(s))
GET_NEXT	JSR	INCNDX	;Increment working index
PRB_SPC2	JSR	PRBYTE	;Display Byte from working index
BR_SPC2		JMP	SPC2	;Send 2 spaces to terminal and return
;
;Disassembler handlers:
;
;LF_BRKT subroutine: send "(" to terminal
LF_BRKT		LDA	#$28	;Get "("
					BRA	BR_COUT	;Send to terminal and return
;
;ZP_IMMEDIATE: two byte instructions: zero-page immediate mode
ZP_IMED		JSR	TWO_BYTE	;Display operand byte, then mnemonic
					LDA	#$23	;Get "#" character
					JSR	CHROUT	;Send to terminal
					BRA	PRT1_OP	;Display operand byte again, return
;
;ACC_MODE: single byte A reg mode instructions: implied mode 
ACC_MODE	JSR	IMPLIED	;Send 10 spaces to terminal then display mnemonic
					LDA	#$41	;Get "A" character
BR_COUT		JMP	CHROUT	;Send it and return
;
;ABSOLUTE: three byte instructions: absolute mode 
ABSOLUTE	JSR	TRI_BYTE	;Display operand bytes, then mnemonic
;
;Print 2 Operands: display operand bytes of a three-byte instruction
PRT2_OP		JSR	DOLLAR	;Send "$" to terminal
					LDA	CRCHI	;Load operand high byte
					JSR	PRBYTE	;Send to terminal
BR_PRBTE	LDA	CRCLO	;Load operand low byte
					JMP	PRBYTE	;Send to terminal and return
;
;ZP_ABS: two byte instructions: zero-page absolute
ZP_ABS		JSR	TWO_BYTE	;Display operand byte, then mnemonic
;
;Print 1 Operand byte: display operand byte of a two-byte instruction 
PRT1_OP		JSR	DOLLAR	;Send "$" to terminal
					BRA	BR_PRBTE	;Branch to complete
;
;INDIRECT: two or three byte instructions: indirect modes
INDIRECT	LDA	OPCODE	;Read saved opcode byte
					CMP	#$6C	;Check for JMP(INDIRECT)
					BNE	ZP_IND	;Branch if not
;
					JSR	TRI_BYTE	;Display operand bytes, then mnemonic
					JSR	LF_BRKT	;Send "(" to terminal
					JSR	PRT2_OP	;Display operand bytes again
					BRA	RT_BRKT	;Send ")" to terminal, return
;
;Following group is used multiple times, space savings
DSPLY3		JSR	TWO_BYTE	;Display operand byte, then mnemonic
					JSR	LF_BRKT	;Send "(" to terminal
					BRA	PRT1_OP	;Display operand byte again, return
;
;this is for a two byte instruction: zero page indirect mode 
ZP_IND		JSR	DSPLY3	;Do the 3 routines
;
;RT_BRKT subroutine: send ")" to terminal
RT_BRKT		LDA	#$29	;Get ")"
					BRA	BR_COUT	;Send to terminal and return
;
;ZP_ABS_X: two byte instructions: zero-page absolute indexed by X mode  
ZP_ABS_X	JSR	ZP_ABS	;Display operand byte, mnemonic, operand byte
;
;Print Comma,X: send ",X" to terminal
COM_X			LDA	#$2C	;Get ","
					JSR	CHROUT	;Send to terminal
					LDA	#$58	;Get "X"
					BRA	BR_COUT	;Send to terminal, return
;
;ZP_ABS_Y: two byte instructions: zero-page absolute indexed by Y mode
ZP_ABS_Y	JSR	ZP_ABS	;Display operand byte, mnemonic, operand byte
;
;Print Comma,Y: send ",Y" to terminal
COM_Y			LDA	#$2C	;Get ","
					JSR	CHROUT	;Send to terminal
					LDA	#$59	;Get "Y"
					BRA	BR_COUT	;Send to terminal, return
;
;ABS_Y: three byte instructions: absolute indexed by Y mode
;ABS_X: three byte instructions: absolute indexed by X mode
ABS_Y			SMB6	TEMP2
ABS_X			JSR	TRI_BYTE	;Display operand bytes, then mnemonic
					JSR	PRT2_OP	;Display operand bytes again
					BBS6	TEMP2,COM_Y
					BRA	COM_X	;Send ",X" to terminal, return
;
;ZP_IND_X: two byte instructions: zero-page indirect pre-indexed by X mode  
ZP_IND_X	JSR	DSPLY3	;Do the 3 routines
					JSR	COM_X	;Send ",X" to terminal
					BRA	RT_BRKT	;Send ")" to terminal, return
;
;ZP_IND_Y: two byte instructions: zero-page indirect post-indexed by Y mode 
ZP_IND_Y	JSR	DSPLY3	;Do the 3 routines
					JSR	RT_BRKT	;Send ")" to terminal
					BRA	COM_Y	;Send ",Y" to terminal, return
;
;IND_ABS_X: three byte instruction: JMP (INDIRECT,X) 16 bit indirect
IND_ABS_X	JSR	TRI_BYTE	;Display operand bytes, then mnemonic
					JSR	LF_BRKT	;Send "(" to terminal
					JSR	PRT2_OP	;Display operand bytes again
					JSR	COM_X	;Send ",X" to terminal
					BRA	RT_BRKT	;Send ")" to terminal then done INDABSX handler, RETURN
;
;ZP_XMB: two byte instructions: zero page set/clear memory bit
ZP_XMB		JSR	SRMB	;Display operand byte, mnemonic, isolate bit selector from opcode
					CMP	#$08	;Check if 0-7 or 8-F
					BCC	SRBIT	;Just add $30 (0-7)
					SBC	#$08	;Subtract $08 - convert $8-$F to $0-$7
SRBIT			CLC	;Convert bit selector value to an ASCII decimal digit
					ADC	#$30	;add "0" to bit selector value
					JSR	CHROUT	;Send digit to terminal
					JSR	SPC	;Send a space to terminal
					BRA	PRT1_OP	;Display operand byte again then return
;
;ZP_BBX: three byte instruction: branch on zero-page bit set/clear
ZP_BBX		JSR	SRMB2	;Display operand bytes, mnemonic, isolate bit selector from opcode
					CMP	#$08	;Check if $0-$7 or $8-$F
					BCC	SRBIT2	;Just add $30 ($0-$7)
					SBC	#$08	;Subtract $08 - convert $8-$F to $0-$7
SRBIT2		JSR	SRBIT	;Convert and display bit selector digit
					LDA	CRCHI	;Move second operand to first operand position: 
					STA	CRCLO	;CRCLO = branch offset
					JSR	SPC	;Send a space to terminal
					BRA	BBX_REL	;Display branch target address then return
;
;RELATIVE BRANCH: two byte relative branch mode
;BBX_REL: three byte relative branch mode
;both calculate then display relative branch target address 
REL_BRA		JSR	TWO_BYTE	;Display operand byte, then mnemonic
BBX_REL		JSR	DOLLAR	;Send "$" to terminal
					JSR	INCINDEX	;Increment working address, ref for branch offset
					LDA	CRCLO	;Get branch operand value
					BMI	BRA_MINUS	;Check for $80 or higher (if branch is + or -)
					CLC	;Clear carry for add
					ADC	INDEXL	;Add to Index lo
					TAY	;Xfer to Y reg
					LDA	INDEXH	;Get Index Hi
					ADC	#$00	;Add result from Carry flag to A reg
					BRA	REL_EXT	;Print offset, cleanup, return
BRA_MINUS	EOR	#$FF	;Get 1's complement of offset
					INC	A	;Increment by 1
					STA  TEMP3	;Save result
					SEC	;Set carry for subtract
					LDA	INDEXL	;Get address low
					SBC	TEMP3	;Subtract branch offset
					TAY	;Xfer to Y reg
					LDA	INDEXH	;Get address high
					SBC	#$00	;Subtract carry flag
REL_EXT		JSR	PRWORD	;Send address to terminal
					JMP	DECINDEX	;Decrement working address, return
;
;SRMB2 subroutine: display 2 operand bytes, mnemonic, isolate bit selector from opcode 
;SRMB subroutine: display 1 operand byte, mnemonic, isolate bit selector from opcode 
SRMB2			LDA	(INDEXL)	;Read from working index
					PHA	;Save byte to stack
					JSR	TRI_BYTE	;Display operand bytes and mnemonic 
					BRA	SRM	;Skip down
SRMB			LDA	(INDEXL)	;Read from working index
					PHA	;Save byte on STACK
					JSR	TWO_BYTE	;Display operand byte and mnemonic 
SRM				JSR	BSOUT2T	;Send 2 Backspaces
					PLA	;Restore byte from stack
					LSR	A	;Shift high nibble to low nibble
					LSR	A
					LSR	A
					LSR	A
NOCHAR		RTS	;Done SRMB2/SRMB, return
;
;END OF DISASSEMBLER CODE
;
;[CNTRL-V] Version command:
VER				LDA	#$15	;Get Intro substring (version)
					JSR	PROMPT	;Send to terminal
					LDY	#>BIOS_MSG	;Get high offset
					LDA	#<BIOS_MSG	;Get low offset
PROMPTR		STY	PROMPTH	;Store hi byte
					STA	PROMPTL	;Store lo byte
					BRA	PROMPT2	;Print message
;
;[CNTRL-Q] Query command:
QUERY			LDA	#$2C	;Get Query msg #
;
;PROMPT routine: Send indexed text string to terminal. Index is A reg
;string buffer address is stored in variable PROMPTL, PROMPTH
;Routine is placed here in the Commands area to save ROM space
PROMPT		ASL	A	;Multiply by two for msg table index
					TAY	;Xfer to index
					LDA	MSG_TABLE,Y	;Get low byte address
					STA	PROMPTL	;Store in Buffer pointer
					LDA	MSG_TABLE+1,Y	;Get high byte address
					STA	PROMPTH	;Store in Buffer pointer
;					
PROMPT2		LDA	(PROMPTL)	;Get string data
					BEQ	NOCHAR	;If null character, exit (borrowed RTS)
					JSR	CHROUT	;Send character to terminal
					INC	PROMPTL	;Increment low byte index
					BNE	PROMPT2	;Loop back for next character
					INC	PROMPTH	;Increment high byte index
					BRA	PROMPT2	;Loop back and continue printing
;
;[CNTL-T] UPTIME command: Sends a string to the terminal showing the uptime
; of the system since the last system reset. This routine uses the RTC values
; for Days, Hours, Minutes and seconds. It converts each to BCD and outputs
; to the terminal with text fields. The routine does not calculate months/years
;
UPTIME		LDA	#$1A	;Get Uptime message
					JSR	PROMPT	;Send to terminal
;
					LDX	#$1B	;Get Days message
					LDA	DAYSL	;Get Days low byte
					LDY	DAYSH	;Get Days high byte
					JSR	DO16TIME	;Convert and send to terminal
;
					LDX	#$1C	;Get Hours message
					LDA	HOURS	;Get Current Hours (low byte)
					JSR	DO8TIME	;Convert and send to terminal
;
					LDX	#$1D	;Get Minutes message
					LDA	MINS	;Get Current Minutes (low byte)
					JSR	DO8TIME	;Convert and send to terminal
;
					LDX	#$1E	;Get seconds message
					LDA	SECS	;Get Current Seconds (low byte)
;
DO8TIME		LDY	#$00	;Zero high byte
DO16TIME	PHX	;Push message number to stack
					JSR	HEX2ASC	;Convert and print ASCII string
					PLA	;Pull message number from stack
					BRA	PROMPT	;Branch to Prompt
;
;[CNTRL-L] Xmodem/CRC Loader command: receives a file from console via Xmodem protocol
; no cable swapping needed, uses existing console port and buffer via the terminal program
; not a full blown Xmodem/CRC implementation, only does CRC-16 checking, no fallback
; designed specifically for direct attach to host machine via com port
; can handle full 8-bit binary transfers without error
; tested with ExtraPutty and TeraTerm (Note: TeraTerm doesn't respond to CAN properly)
;
; Added support for Motorola S-Record formatted files automatically
; A parameter input is used as either a Load address for any non-S-record file
; If the received file has a valid S-Record format, the parameter is used as a
; positive address Offset applied to the specified load address in the S-record file
; supported format is S19 as created by the WDC Tools linker.
; Note: this code supports the execution address in the final S9 record, but WDC Tools
; does not provide any ability to put this into their code build. WDC are aware of this
;
XMODEM		SMB7	CMDFLAG	;Set Command flag
					STZ	XMFLAG	;Clear Xmodem flag
					LDA	#$01	;Set block count to one
					STA	BLKNO	;Save it for starting block #
					LDA	#$27	;Get Xmodem intro msg
					JSR	HEX4	;Print Msg, get Hex load address/S-record Offset
					JSR	CROUT	;Send a C/R to show input entered
					CPX	#$00	;Check for input entered (if non-zero, use new data)
					BNE	XLINE	;Branch if data entered
					TXA	;Xfer to A reg (LDA #$00)
					LDY	#$08	;Set High byte ($0800)
XLINE			STA	PTRL	;Store to Lo pointer
					STY	PTRH	;Store to Hi pointer
;Wait for 5 seconds for user to setup xfer from terminal
					LDA	#$02	;Load milliseconds = 2 ms
					LDX	#$0A	;Load High multipler to 10 decimal
					LDY	#$FA	;Load Low multipler to 250 decimal
					JSR	SET_DLY	;Set Delay parameters
					JSR	EXE_LGDLY	;Call long delay for 5 seconds
;
STRT_XFER	LDA	#'C'	;Send "C" character for CRC mode
					JSR	CHROUT	;Send to terminal
CHR_DLY		JSR	EXE_MSDLY	;Delay 2 milliseconds
					LDA	ICNT	;Check input buffer count
					BNE	STRT_BLK	;If a character is in, branch
					DEY	;Decrement loop count (250 1st time only)
					BNE	CHR_DLY	;Branch and check again 250/256 times
					BRA	STRT_XFER	;Else, branch and send another "C"
;
XDONE			LDA	#ACK	;Last block, get ACK character
					JSR	CHROUT	;Send final ACK
					LDY	#$02	;Get delay count
					LDA	#$28	;Get Good xfer message number
FLSH_DLY	JSR NOLOOPS	;Zero input buffer pointers
					PHA	;Save Message number
					LDA	#$FA	;Load milliseconds = 250 ms
					LDX	#$00	;Load High multipler to 0 decimal
					JSR	SET_DLY	;Set Delay parameters
					JSR	EXE_LGDLY	;Execute delay, (wait to get terminal back)
					PLA	;Get message number back
					CMP	#$29	;Check for error msg#
					BEQ	SHRT_EXIT	;Do only one message
					PHA	;Save MSG number
					BBR7	XMFLAG,END_LOAD	;Branch if no S-record
					LDA	#$2A	;Get S-Record load address msg
					JSR	PROMPT	;Printer header msg
					LDA	SRCH	;Get source high byte
					LDY	SRCL	;Get source low byte
					JSR	PRWORD	;Print Hex address
					JSR	CROUT	;Print C/R and return
END_LOAD	PLA	;Get Message number
SHRT_EXIT	JMP	PROMPT	;Print Message and exit
;
STRT_BLK	JSR	CHRIN	;Get a character
					CMP	#$1B	;Is it escape - quit?
					BEQ	XM_END	;If yes, exit
					CMP	#SOH	;Start of header?
					BEQ	GET_BLK	;If yes, branch and receive block
					CMP	#EOT	;End of Transmission?
					BEQ	XDONE	;If yes, branch and exit
					BRA	STRT_ERR	;Else branch to error
XM_END		RTS	;Cancelled by user, return
;
GET_BLK		SMB6	XMFLAG	;Set bit 6 for Xmodem xfer
					LDX	#$00	;Zero index for block receive
;
GET_BLK1	JSR	CHRIN	;Get a character
					STA	RBUFF,X	;Move into buffer
					INX	;Increment buffer index
					CPX	#$84	;Compare size (<01><FE><128 bytes><CRCH><CRCL>)
					BNE	GET_BLK1	;If not done, loop back and continue
					RMB6	XMFLAG	;Reset Xmodem xfer bit (allows break)
;
					LDA	RBUFF	;Get block number from buffer
					CMP	BLKNO	;Compare to expected block number
					BNE	RESTRT	;If not correct, restart the block
					EOR	#$FF	;one's complement of block number
					CMP	RBUFF+1	;Compare with expected one's complement of block number
					BEQ	BLK_OKAY	;Branch if compare is good
;
RESTRT		LDA	#NAK	;Get NAK character
RESTRT2		JSR	CHROUT	;Send to xfer program
					BRA	STRT_BLK	;Restart block transfer
;
BLK_OKAY	LDA	#$0A	;Set retry value to 10
					STA	CRCCNT	;Save it to CRC retry count
					STZ	CRCLO	;Reset the CRC value by (3)
					STZ	CRCHI	;putting all bits off (3)
					LDY #$00	;Set index for data offset (2)
CALCCRC		LDA	RBUFF+2,Y	;Get first data byte (4)
					PHP	;Save status reg (3)
					LDX	#$08	;Load index for 8 bits (2)
					EOR	CRCHI	;XOR High CRC byte
CRCLOOP		ASL	CRCLO	;Shift carry to CRC low byte (4)
					ROL	A	;Shift bit to carry flag (2)
					BCC	CRCLP1	;Branch if MSB is 1 (2/3)
					EOR	#$10	;Exclusive OR with polynomial (2)
					PHA	;Save result on stack (3)
					LDA	CRCLO	;Get CRC low byte (3)
					EOR	#$21	;Exclusive OR with polynomial (2)
					STA	CRCLO	;Save it back (3)
					PLA	;Get previous result (4)
CRCLP1		DEX	;Decrement index (2)
					BNE	CRCLOOP	;Loop back for all 8 bits (2/3)
					STA	CRCHI	;Update CRC high byte (3)
					PLP ;Restore status reg (4)
					INY	;Increment index to the next data byte (2)
					BPL	CALCCRC	;Branch back until all 128 fed to CRC routine (2/3)
					LDA	RBUFF+2,Y	;Get received CRC hi byte (4)
					CMP	CRCHI	;Compare against calculated CRC hi byte (3)
					BNE	BADCRC	;If bad CRC, handle error (2/3)
					LDA	RBUFF+3,Y	;Get CRC lo byte (4)
					CMP	CRCLO	;Compare against calculated CRC lo byte (3)
					BEQ	GOODCRC	;If good, go move frame to memory (2/3)
;
;CRC was bad... need to retry and receive the last frame again
;Decrement the CRC retry count, send a NAK and try again
;Count allows up to 10 retries, then cancels the transfer
;
BADCRC		DEC	CRCCNT	;Decrement retry count
					BNE	CRCRTRY	;Retry again if count not zero
STRT_ERR	LDA	#CAN	;Else get Cancel code
					JSR	CHROUT	;Send it to terminal program
					LDY	#$08	;Set delay multiplier
					LDA	#$29	;Get message for receive error
					JMP	FLSH_DLY	;Do a flush, delay and exit
CRCRTRY		JSR	NOLOOPS	;Zero Input buffer pointers
					BRA	RESTRT	;Send NAK and retry
;
;Block has been received, check for S19 record transfer
GOODCRC		BBS7	XMFLAG,XFER_S19	;Branch if bit 7 set (active S-record)
					LDA	BLKNO	;Else, check current block number
					DEC	A	;Check for block 1 only (first time thru)
					BEQ	TEST_S19	;If yes, test for S19 record
;
MOVE_BLK	LDX	#$00	;Zero index offset to data
COPYBLK		LDA	RBUFF+2,X	;Get data byte from buffer
					STA	(PTRL)	;Store to target address
					INC	PTRL	;Incrememnt low address byte
					BNE	COPYBLK2	;Check for hi byte loop
					INC	PTRH	;Increment hi byte address
COPYBLK2	INX	;Point to next data byte
					BPL	COPYBLK	;Loop back until done (128)
INCBLK		INC	BLKNO	;Increment block number
					LDA	#ACK	;Get ACK character
					BRA	RESTRT2	;Send ACK and continue xfer
;
TEST_S19	LDA	RBUFF+2	;Get first character
					CMP	#'S'	;Check for S character
					BNE	MOVE_BLK	;If not equal, no S-record, move block
					LDA	RBUFF+3	;Get second character
					CMP	#'1'	;Check for 1 character
					BNE	MOVE_BLK	;If not equal, no S-record, move block
					SMB7	XMFLAG	;Set bit 7 for S-record xfer
					STZ	IDY	;Zero index for SRBUFF
;
; S-record transfer routine
;	Xmodem is a 128 byte data block, S-record is variable, up to 44 byte block
;	need to move a record at a time to the SRBUFF based on length, check as valid,
;	then calculate address and transfer to that location
;	once the Xmodem buffer is empty, loop back to get the next frame
;	and continue processing S-records until completed
;
;At first entry here, pointer IDY is zero
;At all entries here, a 128 byte block has been received
;The S-record length needs to be calculated, then the proper count moved
;to the SRBUFF location and both pointers (IDX/IDY) updated
;
XFER_S19	STZ	IDX	;Zero offset to RBUFF
S19_LOOP2	LDX	IDX	;Load current offset to RBUFF
					LDY	IDY	;Get S-Record offset
S19_LOOP	LDA	RBUFF+2,X	;Get S-Record data
					STA	SRBUFF,Y	;Save it to the S-record buffer
					INX	;Increment offset to RBUFF
					CPX	#$81	;Check for end of RBUFF data
					BEQ	NXT_FRAME	;If yes, go back and get another frame
					INY	;Increment S-Rec size
					CPY	#$2C	;Check for size match
					BNE	S19_LOOP	;Branch back until done
					STX	IDX	;Update running offset to RBUFF
					STZ	IDY	;Reset SRBUFF index pointer
					JSR	SREC_PROC	;Process the S-Record and store in memory
					BRA	S19_LOOP2	;Branch back and get another record
NXT_FRAME	STY	IDY	;Save SRBUFF offset
INCBLK2		BRA	INCBLK	;Increment block and get next frame
;
SREC_PROC	LDA	SRBUFF+1	;Get the Record type character
					CMP	#'1'	;Check for S1 record
					BEQ	S1_PROC	;Process a S1 record
					CMP	#'9'	;Check for S9 (final) record
					BEQ	S9_PROC	;Process a S9 record
SREC_ERR	PLA	;Else, pull return address
					PLA	;of two bytes from stack
					BRA	STRT_ERR	;Branch to Xmodem error/exit routine
;
SR_PROC		LDY	SRBUFF+3	;Get record length LS character
					LDA	SRBUFF+2	;Get record length MS character
					JSR	ASC2BIN	;Convert to single byte for length
					INC	A	;Add one to length to include checksum
					STA	TEMP3	;Save record length
;
; If record length is less, than the difference needs to be subtracted from IDX
; which reflects either the last record (S9) or a S1 record of a lesser length
;
					SEC	;Set carry for subtract
					LDA	#20	;Get default count
					SBC	TEMP3	;Subtract actual length
					ASL	A	;Multiply by two for characters pairs
					STA	TEMP2	;Save it to temp
;
					SEC	;Set carry for subtract
					LDA	IDX	;Get RBUFF index
					SBC	TEMP2	;Subtract difference
					STA	IDX	;Update IDX
;
SR_COMP		LDX	#$00	;Zero Index
					LDY	#$00	;Zero Index
SR_CMPLP	PHY	;Save Y reg index
					LDY	SRBUFF+3,X	;get LS character
					LDA	SRBUFF+2,X	;Get MS character
					JSR	ASC2BIN	;Convert two ASCII characters to HEX byte
					PLY	;Restore Y reg index
					STA	SRBUFF,Y	;Store in SRBUFF starting at front
					INX	;Increment X reg twice
					INX	;points to next character pair
					INY	;Increment Y reg once for offset to SRBUFF
					DEC	TEMP3	;Decrement character count
					BNE	SR_CMPLP	;Branch back until done
;
; SRBUFF now has the compressed HEX data, which is:
; 1 byte for length, 2 bytes for the load address,
; up to 16 bytes for data and 1 byte checksum
; Now calculate the checksum and ensure valid S-record content
;
					STZ	CRCLO	;Zero Checksum location
					LDX	SRBUFF	;Load index with record length
					LDY	#$00	;Zero index
SR_CHKSM	CLC	;Clear carry for add
					LDA	SRBUFF,Y	;Get Srec byte
					ADC	CRCLO	;Add in checksum Temp
					STA	CRCLO	;Update checksum Temp
					INY	;Increment offset
					DEX	;Decrement count
					BNE	SR_CHKSM	;Branch back until done
;
					LDA	#$FF	;Get all bits on
					EOR	CRCLO	;Exclusive OR TEMP for one's complement
					CMP	SRBUFF,Y	;Compare to last byte (which is checksum)
					BNE	SREC_ERR	;If bad, exit out
					RTS	;Return to caller
;
S9_PROC		JSR	SR_PROC	;Process the S-Record and checksum
					LDA	SRBUFF+1	;Get MSB load address
					STA	COMHI	;Store to execution pointer
					LDA	SRBUFF+2	;Get LSB load address
					STA	COMLO	;Store to execution pointer
					PLA	;Pull return address
					PLA	;second byte
					BRA	INCBLK2	;Branch back to close out transfer
;
S1_PROC		JSR	SR_PROC	;Process the S-Record and checksum
;
; Valid binary S-Record decoded at SRBUFF
; Calculate offset from input, add to specified load address
; and store into memory, then loop back until done
;
; Offset is stored in PTR L/H from initial input
; if no input entered, BUFIDX is zero and PTR L/H is preset to $0800
; so checking for BUFIDX being zero bypasses adding the offset,
; if BUFIDX is non zero, then PTR L/H contains the offset address
; which is added to TGT L/H moving the S-record data to memory
;
					LDA	SRBUFF+1	;Get MS load address
					STA	TGTH	;Store to target pointer
					LDA	SRBUFF+2	;Get LS load address
					STA	TGTL	;Store to target pointer
					LDA	BUFIDX	;Check input count for offset required
					BEQ	NO_OFFSET	;If Zero, no offset was entered
;
; Add in offset contained at PTR L/H to TGT L/H
;
					CLC	;Clear carry for add
					LDA	PTRL	;Get LS offset
					ADC	TGTL	;Add to TGTL address
					BCC	SKIP_HB	;Skip increment HB if no carry
					INC	TGTH	;Else increment TGTH by one
SKIP_HB		STA	TGTL	;Save TGTL
					LDA	PTRH	;Get MS offset
					ADC	TGTH	;Add to TGTH
					STA	TGTH	;Save it
;
; Check for first Block and load SRC H/L with load address
;
NO_OFFSET	LDA	BLKNO	;Get Block number
					DEC	A	;Decrement to test for block one
					BNE	NO_OFFST2	;If not first block, skip around
					LDA	IDX	;Get running count for first block
					CMP	#$2C	;First S-record?
					BNE	NO_OFFST2	;If yes, setup load address pointer
					LDA	TGTL	;Get starting address Lo byte
					STA	SRCL	;Save it as Source Lo byte
					LDA	TGTH	;Get starting address Hi byte
					STA	SRCH	;Save it as Source Hi byte
;
NO_OFFST2	LDX	SRBUFF	;Get record length
					DEX	;Decrement by 3
					DEX	; to only transfer the data
					DEX	; and not the count and load address
					LDY	#$00	;Zero index
MVE_SREC	LDA	SRBUFF+3,Y	;Get offset to data in record
					STA	(TGTL),Y	;Store it to memory
					INY	;Increment index
					DEX	;Decrement record count
					BNE	MVE_SREC	;Branch back until done
					RTS	;Return to caller
;
;[CNTL-R]	Reset System command: Resets system by calling Coldstart routine
;	Page zero is cleared, vectors and config data re-initialized from ROM
;	All I/O devices reset from initial ROM parameters, Monitor cold start entered
;
SYS_RST		LDA	#$20	;Get msg "Reset System"
					SMB0	CMDFLAG	;Set bit zero
					BRA	RST_ONLY	;Branch below and handle reset
;
;[CNTL-Z] Zero command: zero RAM from $0100-$7FFF and Reset
ZERO			LDA	#$1F	;Get msg "Zero RAM/Reset System"
RST_ONLY	JSR	PROMPT	;Send to terminal
					JSR	CONTINUE	;Prompt for Continue
					BBS0	CMDFLAG,DO_COLD	;Branch if reset only
					SEI	;Disable IRQs
					LDA	#$01	;Initialize address pointer to $0100
					STA	$01	;Store to pointer high byte
					STZ	$00	;Zero address low byte
					DEC	A	;LDA #$00
ZEROLOOP	STA	($00)	;Write $00 to current address
					INC	$00	;Increment address pointer
					BNE	ZEROLOOP
					INC	$01
					BPL	ZEROLOOP	;LOOP back IF address pointer < $8000
DO_COLD		JMP	COLDSTRT	;Jump to coldstart vector
;
;END OF MONITOR CODE
;******************************************************************************
;
;******************************************************************************
;START OF MONITOR DATA
;******************************************************************************
;
;* Monitor command & jump table *
;
;There are two parts to the monitor command and jump table;
; first is the list of commands, which are one byte each. Alpha command characters are upper case
; second is the 16-bit address table that correspond to the command routines for each command character
;
MONCMD		.BYTE $02 ;[CNTRL-B] Enter EhBasic
					.BYTE	$04	;[CNTRL-D]	Disassembler
					.BYTE	$0C	;[CNTRL-L]	Xmodem/CRC Loader
					.BYTE	$10	;[CNTRL-P]	Program EEPROM
					.BYTE	$11	;[CNTRL-Q]	Query Monitor Commands
					.BYTE	$12	;[CNTRL-R]	Reset - same as power up
					.BYTE	$14	;[CNTRL-T]	Uptime display since reset
					.BYTE	$16	;[CNTRL-V]	Display Monitor Version
					.BYTE	$1A	;[CNTRL-Z]	Zero Memory - calls reset
					.BYTE	$28	;(	Init Macro
					.BYTE	$29	;)	Run Macro
					.BYTE	$2C	;,	Setup Delay parameters	
					.BYTE	$2E	;.	Execute Millisecond Delay
					.BYTE	$2F	;/	Execute Long Delay
					.BYTE	$5C	;\	Load and Go Extra Long Delay
					.BYTE	$41	;A	Display/Edit A register
					.BYTE	$43	;C	Compare memory block
					.BYTE	$44	;D	Display Memory contents in HEX/TEXT
					.BYTE	$45	;E	Examine/Edit memory
					.BYTE	$46	;F	Fill memory block
					.BYTE	$47	;G	Go execute to <addr>
					.BYTE	$48	;H	Hex byte string search
					.BYTE	$49	;I	Input Text string
					.BYTE	$4D	;M	Move memory block
					.BYTE	$50	;P	Display/Edit CPU status reg
					.BYTE	$52	;R	Display Registers
					.BYTE	$53	;S	Display/Edit stack pointer
					.BYTE	$54	;T	Text character string search
					.BYTE	$58	;X	Display/Edit X register
					.BYTE	$59	;Y	Display/Edit Y register
;
MONTAB		.WORD EHBASIC ;[CNTRL-B] $02 Start EhBasic
					.WORD	DSSMBLR	;[CNTRL-D] $04	Disassembler
					.WORD	XMODEM	;[CNTL-L]	$0C	Xmodem download, use send from terminal program
					.WORD	PROGEE ;[CNTL-P]	$10	Program the EEPROM
					.WORD	QUERY	;[CNTL-Q]	$11	Query Monitor Commands
					.WORD	SYS_RST	;[CNTL-R]	$12	Reset CO2Monitor
					.WORD	UPTIME	;[CNTL-T]	$14	System uptime from Reset - sec/min/hr/days
					.WORD	VER	;[CNTL-V]	$16	Display Monitor Version level
					.WORD	ZERO	;[CNTL-Z]	$1A	Zero memory ($0100-$7FFF) then Reset
					.WORD	INIMACRO	; (	$28	Clear keystroke input buffer, reset buffer pointer
					.WORD	RUNMACRO	; )	$29	Run keystroke macro from start of keystroke buffer
					.WORD	SET_DELAY	; .	$2C	Setup Delay Parameters
					.WORD	EXE_MSDLY	; ,	$2E	Perform Millisecond Delay
					.WORD	EXE_LGDLY	;	/	$2F Execute Long Delay
					.WORD	SET_XLDLY	;	\	$5C Load and Go Extra Long Delay
					.WORD	ARG	; A	$41	Examine/change ACCUMULATOR preset/result
					.WORD	CPMVFL	; C	$43	Compare command - new
					.WORD	MDUMP	; D	$44	HEX/TEXT dump from specified memory address
					.WORD	CHANGE	; E	$45	Examine/change a memory location's contents
					.WORD	CPMVFL	; F	$46	Fill a specified memory range with a specified value
					.WORD	GO	; G	$47	Begin program code execution at a specified address
					.WORD	SRCHBYT	; H	$48	Search memory for a specified byte string
					.WORD	TEXT	; I	$49 Input text string into memory
					.WORD	CPMVFL	; M	$4D	Copy a specified memory range to a specified target address
					.WORD	PRG	; P	$50	Examine/change PROCESSOR STATUS REGISTER preset/result
					.WORD	PRSTAT	; R	$52	Display all preset/result contents
					.WORD	SRG	; S	$53	Examine/change STACK POINTER preset/result
					.WORD	SRCHTXT	; T	$54	Search memory for a specified text string
					.WORD	XRG	; X	$58	Examine/change X-REGISTER preset/result
					.WORD	YRG	; Y	$59	Examine/change Y-REGISTER preset/result
;
;******************************************************************************
;C02Monitor message strings used with PROMPT routine, terminated with $00
;
MSG_00		.BYTE " cont?"
MSG_01		.BYTE	"(y/n)"
					.BYTE $00
MSG_02		.BYTE $0D,$0A
					.BYTE	"   "
MSG_03		.BYTE	" addr:"
					.BYTE $00
MSG_04		.BYTE " len:"
					.BYTE $00
MSG_05		.BYTE " val:"
					.BYTE $00
MSG_06		.BYTE " src:"
					.BYTE $00
MSG_07		.BYTE " tgt:"
					.BYTE $00
MSG_08		.BYTE " find txt:"
					.BYTE $00
MSG_09		.BYTE " find bin:"
					.BYTE $00
MSG_0A		.BYTE "not "
MSG_0B		.BYTE "found"
					.BYTE $00
MSG_0C		.BYTE $0D,$0A
					.BYTE "search- "
					.BYTE $00
MSG_0D		.BYTE $0D,$0A
					.BYTE "(n)ext? "
					.BYTE $00
MSG_0E		.BYTE "SR:$"
					.BYTE $00
MSG_0F		.BYTE "SP:$"
					.BYTE $00
MSG_10		.BYTE "YR:$"
					.BYTE $00
MSG_11		.BYTE "XR:$"
					.BYTE $00
MSG_12		.BYTE "AC:$"
					.BYTE $00
MSG_13		.BYTE	$0D,$0A
					.BYTE "   PC  AC XR YR SP NV-BDIZC",$0D,$0A
					.BYTE "; "
					.BYTE $00
MSG_14		.BYTE $0D,$0A
					.BYTE "C02Monitor (c)2016 K.E.Maier",$07
MSG_15		.BYTE $0D,$0A
					.BYTE "Version 1.4"
					.BYTE $00
MSG_16		.BYTE $0D,$0A
					.BYTE ";-"
					.BYTE $00
MSG_17		.BYTE	" delay ms:"
					.BYTE	$00
MSG_18		.BYTE	" mult:"
					.BYTE	$00
MSG_19		.BYTE	" delay xl:"
					.BYTE	$00
MSG_1A		.BYTE	"Uptime: "
					.BYTE	$00
MSG_1B		.BYTE	" Days, "
					.BYTE	$00
MSG_1C		.BYTE	" Hours, "
					.BYTE	$00
MSG_1D		.BYTE	" Minutes, "
					.BYTE	$00
MSG_1E		.BYTE	" Seconds"
					.BYTE	$00
MSG_1F		.BYTE "Zero RAM/"
MSG_20		.BYTE	"Reset,"
					.BYTE	$00
MSG_21		.BYTE	"Program EEPROM",$0D,$0A
					.BYTE	$00
MSG_22		.BYTE	$0D,$0A
					.BYTE	"Are you sure? "
					.BYTE	$00
MSG_23		.BYTE	$0D,$0A
					.BYTE	"Writing EEPROM."
					.BYTE	$00
MSG_24		.BYTE	$0D,$0A
					.BYTE	"EEPROM Write Complete!"
					.BYTE	$00
MSG_25		.BYTE	$0D,$0A
					.BYTE	"EEPROM Write Failed!",$0D,$0A
					.BYTE	"Hardware or EEPROM jumper!"
MSG_26		.BYTE	$0D,$0A
					.BYTE	"RTC time error, check/reset!"
					.BYTE	$00
MSG_27		.BYTE	"XMODEM Loader, <Esc> to abort, or",$0D,$0A
					.BYTE	"Load Address/S-Record Offset:"
					.BYTE	$00
MSG_28		.BYTE	$0D,$0A
					.BYTE	"Download Complete!",$0A
					.BYTE	$00
MSG_29		.BYTE	$0D,$0A
					.BYTE	"Download Error!",$0A
					.BYTE	$00
MSG_2A		.BYTE $0D,$0A
					.BYTE "S-Record load at:$"
					.BYTE $00
MSG_2B		.BYTE	$0D,$0A
					.BYTE	"Disassembly from"
					.BYTE	$00
MSG_2C		.BYTE	$0D,$0A,$0A
					.BYTE	"Memory Ops: "
					.BYTE	"[C]ompare, "
					.BYTE	"[D]isplay, "
					.BYTE	"[E]dit, "
					.BYTE	"[F]ill, "
					.BYTE	"[G]o Exec,",$0D,$0A
					.BYTE	"[H]ex Find, "
					.BYTE	"[I]nput Text, "
					.BYTE	"[M]ove, "
					.BYTE	"[T]ext Find",$0D,$0A,$0A
					.BYTE	"Registers: "
					.BYTE	"R,A,X,Y,S,P",$0D,$0A,$0A
					.BYTE	"Timer: "
					.BYTE	",= set ms|mult, "
					.BYTE	".= exe ms, "
					.BYTE	"/= exe ms*mult, "
					.BYTE	"\= exe (?)*ms*mult",$0D,$0A,$0A
					.BYTE	"Macro: "
					.BYTE	"(= Init "
					.BYTE	")= Run",$0D,$0A,$0A
					.BYTE	"CTRL[?]: "
					.BYTE	"[D]isassemble, "
					.BYTE	"[L]oader, "
					.BYTE	"[P]rogram, "
					.BYTE	"[Q]uery Cmds,",$0D,$0A
					.BYTE	"[R]eset, "
					.BYTE	"[T]ime up, "
					.BYTE	"[V]ersion, "
					.BYTE	"[Z]ero RAM",$0A
					.BYTE	$00
MSG_2D		.BYTE	$0D,$0A
					.BYTE	"Show Loop count "
					.BYTE	$00
MSG_2E		.BYTE	$0D,$0A
					.BYTE	"Loops: "
					.BYTE	$00
MSG_2F  .BYTE     $0D,$0A
        .BYTE     "65C02 Enhanced BASIC Version 2.22p5C02"
        .BYTE     $0D,$0A
        .BYTE     " [C]old/[W]arm start?"
        .BYTE     $00
;
MSG_TABLE	;Message table - contains addresses as words of each message sent via the PROMPT routine
					.WORD MSG_00
					.WORD	MSG_01
					.WORD	MSG_02
					.WORD	MSG_03
					.WORD	MSG_04
					.WORD	MSG_05
					.WORD	MSG_06
					.WORD	MSG_07
					.WORD	MSG_08
					.WORD	MSG_09
					.WORD	MSG_0A
					.WORD	MSG_0B
					.WORD	MSG_0C
					.WORD	MSG_0D
					.WORD	MSG_0E
					.WORD	MSG_0F
					.WORD	MSG_10
					.WORD	MSG_11
					.WORD	MSG_12
					.WORD	MSG_13
					.WORD	MSG_14
					.WORD	MSG_15
					.WORD	MSG_16
					.WORD	MSG_17
					.WORD	MSG_18
					.WORD	MSG_19
					.WORD	MSG_1A
					.WORD	MSG_1B
					.WORD	MSG_1C
					.WORD	MSG_1D
					.WORD	MSG_1E
					.WORD	MSG_1F
					.WORD	MSG_20
					.WORD	MSG_21
					.WORD	MSG_22
					.WORD	MSG_23
					.WORD	MSG_24
					.WORD	MSG_25
					.WORD	MSG_26
					.WORD	MSG_27
					.WORD	MSG_28
					.WORD	MSG_29					
					.WORD	MSG_2A
					.WORD	MSG_2B
					.WORD	MSG_2C
					.WORD	MSG_2D
					.WORD	MSG_2E
					.WORD	MSG_2F
;
;******************************************************************************
;START OF DISASSEMBLER DATA
;
;Pointer for address mode handlers.
;Each byte contains handler pointer for two opcodes;
;Upper nibble for odd, lower nibble for even
HDLR_IDX	.BYTE	$26,$00,$33,$3E,$02,$10,$88,$8F
					.BYTE	$C7,$B0,$34,$4E,$0A,$10,$89,$9F
					.BYTE	$86,$00,$33,$3E,$02,$10,$88,$8F
					.BYTE	$C7,$B0,$44,$4E,$0A,$10,$99,$9F
					.BYTE	$06,$00,$03,$3E,$02,$10,$88,$8F
					.BYTE	$C7,$B0,$04,$4E,$0A,$00,$09,$9F
					.BYTE	$06,$00,$33,$3E,$02,$10,$B8,$8F
					.BYTE	$C7,$B0,$44,$4E,$0A,$00,$D9,$9F
					.BYTE	$C6,$00,$33,$3E,$02,$00,$88,$8F
					.BYTE	$C7,$B0,$44,$5E,$0A,$00,$89,$9F
					.BYTE	$26,$20,$33,$3E,$02,$00,$88,$8F
					.BYTE	$C7,$B0,$44,$5E,$0A,$00,$99,$AF
					.BYTE	$26,$00,$33,$3E,$02,$00,$88,$8F
					.BYTE	$C7,$B0,$04,$4E,$0A,$00,$09,$9F
					.BYTE	$26,$00,$33,$3E,$02,$00,$88,$8F
					.BYTE	$C7,$B0,$04,$4E,$0A,$00,$09,$9F
;
;Disassembler handler table:
;Handler address index: (referenced in table HDLR_IDX)
HDLR_TAB	.WORD	IMPLIED	;$00
					.WORD	ACC_MODE	;$01   
					.WORD	ZP_IMED	;$02
					.WORD	ZP_ABS	;$03
					.WORD	ZP_ABS_X	;$04
					.WORD	ZP_ABS_Y	;$05
					.WORD	ZP_IND_X	;$06
					.WORD	ZP_IND_Y	;$07
					.WORD	ABSOLUTE	;$08
					.WORD	ABS_X	;$09
					.WORD	ABS_Y	;$0A
					.WORD	INDIRECT	;$0B
					.WORD	REL_BRA	;$0C
					.WORD	IND_ABS_X	;$0D
					.WORD	ZP_XMB	;$0E
					.WORD	ZP_BBX	;$0F
;
;Disassembler mnemonic pointer table. This is indexed by the instruction opcode
; The values in this table are an index to the mnemonic data used to print: 
MNE_PTAB	;Mnemonic pointer index table
					.BYTE	$1C,$4C,$00,$00,$82,$4C,$06,$5E,$50,$4C,$06,$00,$82,$4C,$06,$08
					.BYTE	$18,$4C,$4C,$00,$80,$4C,$06,$5E,$22,$4C,$38,$00,$80,$4C,$06,$08
					.BYTE	$40,$04,$00,$00,$12,$04,$60,$5E,$58,$04,$60,$00,$12,$04,$60,$08
					.BYTE	$14,$04,$04,$00,$12,$04,$60,$5E,$6A,$04,$30,$00,$12,$04,$60,$08
					.BYTE	$64,$36,$00,$00,$00,$36,$48,$5E,$4E,$36,$48,$00,$3E,$36,$48,$08
					.BYTE	$1E,$36,$36,$00,$00,$36,$48,$5E,$26,$36,$54,$00,$00,$36,$48,$08
					.BYTE	$66,$02,$00,$00,$7A,$02,$62,$5E,$56,$02,$62,$00,$3E,$02,$62,$08
					.BYTE	$20,$02,$02,$00,$7A,$02,$62,$5E,$6E,$02,$5C,$00,$3E,$02,$62,$08
					.BYTE	$1A,$72,$00,$00,$78,$72,$76,$70,$34,$12,$86,$00,$78,$72,$76,$0A
					.BYTE	$0C,$72,$72,$00,$78,$72,$76,$70,$8A,$72,$88,$00,$7A,$72,$7A,$0A
					.BYTE	$46,$42,$44,$00,$46,$42,$44,$70,$7E,$42,$7C,$00,$46,$42,$44,$0A
					.BYTE	$0E,$42,$42,$00,$46,$42,$44,$70,$28,$42,$84,$00,$46,$42,$44,$0A
					.BYTE	$2E,$2A,$00,$00,$2E,$2A,$30,$70,$3C,$2A,$32,$8C,$2E,$2A,$30,$0A
					.BYTE	$16,$2A,$2A,$00,$00,$2A,$30,$70,$24,$2A,$52,$74,$00,$2A,$30,$0A
					.BYTE	$2C,$68,$00,$00,$2C,$68,$38,$70,$3A,$68,$4A,$00,$2C,$68,$38,$0A
					.BYTE	$10,$68,$68,$00,$00,$68,$38,$70,$6C,$68,$5A,$00,$00,$68,$38,$0A
;
DIS_NMEM	;Mnemonic compressed table
;	Uses two bytes per 3-character Mnemonic. 5-bits per character uses 15-bit total
;	Characters are left to right. 5-bits shifted into A reg, add in $3F and print
;	"?" starts with "00000", "A" starts with "00010", "B" starts with "00011", etc.
;
; A	00010		B	00011		C	00100		D	00101		E	00110		F	00111		G	01000		H	01001
;	I	01010		J	01011		K	01100		L	01101		M	01110		N	01111		O	10000		P	10001
;	Q	10010		R	10011		S	10100		T	10101		U	10110		V	10111		W	11000		X	11001
;	Y	11010		Z	11011
;
					.DBYT	%0000000000000000	;???	$00
					.DBYT	%0001000101001000	;ADC	$02
					.DBYT	%0001001111001010	;AND	$04
					.DBYT	%0001010100011010	;ASL	$06
					.DBYT	%0001100011100110	;BBR	$08
					.DBYT	%0001100011101000	;BBS	$0A
					.DBYT	%0001100100001000	;BCC	$0C
					.DBYT	%0001100100101000	;BCS	$0E
					.DBYT	%0001100110100100	;BEQ	$10
					.DBYT	%0001101010101010	;BIT	$12
					.DBYT	%0001101110010100	;BMI	$14
					.DBYT	%0001101111001100	;BNE	$16
					.DBYT	%0001110001011010	;BPL	$18
					.DBYT	%0001110011000100	;BRA	$1A
					.DBYT	%0001110011011000	;BRK	$1C
					.DBYT	%0001110111001000	;BVC	$1E
					.DBYT	%0001110111101000	;BVS	$20
					.DBYT	%0010001101001000	;CLC	$22
					.DBYT	%0010001101001010	;CLD	$24
					.DBYT	%0010001101010100	;CLI	$26
					.DBYT	%0010001101101110	;CLV	$28
					.DBYT	%0010001110100010	;CMP	$2A
					.DBYT	%0010010001110010	;CPX	$2C
					.DBYT	%0010010001110100	;CPY	$2E
					.DBYT	%0010100110001000	;DEC	$30
					.DBYT	%0010100110110010	;DEX	$32
					.DBYT	%0010100110110100	;DEY	$34
					.DBYT	%0011010000100110	;EOR	$36
					.DBYT	%0101001111001000	;INC	$38
					.DBYT	%0101001111110010	;INX	$3A
					.DBYT	%0101001111110100	;INY	$3C
					.DBYT	%0101101110100010	;JMP	$3E
					.DBYT	%0101110100100110	;JSR	$40
					.DBYT	%0110100101000100	;LDA	$42
					.DBYT	%0110100101110010	;LDX	$44
					.DBYT	%0110100101110100	;LDY	$46
					.DBYT	%0110110100100110	;LSR	$48
					.DBYT	%0111110000100010	;NOP	$4A
					.DBYT	%1000010011000100	;ORA	$4C
					.DBYT	%1000101001000100	;PHA	$4E
					.DBYT	%1000101001100010	;PHP	$50
					.DBYT	%1000101001110010	;PHX	$52
					.DBYT	%1000101001110100	;PHY	$54
					.DBYT	%1000101101000100	;PLA	$56
					.DBYT	%1000101101100010	;PLP	$58
					.DBYT	%1000101101110010	;PLX	$5A
					.DBYT	%1000101101110100	;PLY	$5C
					.DBYT	%1001101110000110	;RMB	$5E
					.DBYT	%1001110000011010	;ROL	$60
					.DBYT	%1001110000100110	;ROR	$62
					.DBYT	%1001110101010100	;RTI	$64
					.DBYT	%1001110101101000	;RTS	$66
					.DBYT	%1010000011001000	;SBC	$68
					.DBYT	%1010000110001000	;SEC	$6A
					.DBYT	%1010000110001010	;SED	$6C
					.DBYT	%1010000110010100	;SEI	$6E
					.DBYT	%1010001110000110	;SMB	$70
					.DBYT	%1010010101000100	;STA	$72
					.DBYT	%1010010101100010	;STP	$74
					.DBYT	%1010010101110010	;STX	$76
					.DBYT	%1010010101110100	;STY	$78
					.DBYT	%1010010101110110	;STZ	$7A
					.DBYT	%1010100010110010	;TAX	$7C
					.DBYT	%1010100010110100	;TAY	$7E
					.DBYT	%1010110011101000	;TRB	$80
					.DBYT	%1010110100000110	;TSB	$82
					.DBYT	%1010110100110010	;TSX	$84
					.DBYT	%1010111001000100	;TXA	$86
					.DBYT	%1010111001101000	;TXS	$88
					.DBYT	%1010111010000100	;TYA	$8A
					.DBYT	%1100000010010100	;WAI	$8C
;
;END OF DISASSEMBLER DATA
;******************************************************************************
;END OF MONITOR DATA
;******************************************************************************
