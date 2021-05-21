.segment "TOP"
;******************************************************************************
; $FF00	;JMP Table, HW Vectors, Cold Init and Vector handlers
;******************************************************************************
; START OF TOP PAGE - DO NOT MOVE FROM THIS ADDRESS!!
;******************************************************************************
;JUMP Table starts here:
;	- BIOS calls are from the top down - total of 16
;	- Monitor calls are from the bottom up
;	- Reserved calls are in the shrinking middle
;
					JMP	RDLINE
					JMP	RDCHAR
					JMP	HEXIN2
					JMP	HEXIN4
					JMP	HEX2ASC
					JMP	BIN2ASC
					JMP	ASC2BIN
					JMP	DOLLAR
					JMP	PRBYTE
					JMP	PRWORD
					JMP	PRASC
					JMP	PROMPT
					JMP	PROMPTR
					JMP	CONTINUE
					JMP	CROUT
					JMP	SPC
					JMP	UPTIME
					JMP	RET
					JMP	RET
					JMP	RET
					JMP	RET
					JMP	RET
					JMP	RET
					JMP	RET
					JMP	CHRIN_NW
					JMP	CHRIN
					JMP	CHROUT
					JMP	SET_DLY
					JMP	EXE_MSDLY
					JMP	EXE_LGDLY
					JMP	EXE_XLDLY
					JMP	SET_PORT
					JMP	IN_PORT
					JMP	OUT_PORT
					JMP	INIT_VEC
					JMP	INIT_CFG
					JMP	INIT_6551
					JMP	INIT_6522
					JMP	(WRMMNVEC0)
CMBV			JMP	(CLDMNVEC0)
;
COLDSTRT	CLD	;Clear decimal mode in case of software call (Zero Ram calls this) (2)
					SEI	;Disable Interrupt for same reason as above (2)
					LDX	#$00	;Index for length of page (2)
PAGE0_LP	STZ	$00,X	;Zero out Page Zero (4)
					DEX	;Decrement index (2)
					BNE	PAGE0_LP	;Loop back till done (2/3)
					DEX	;LDX #$FF ;-) (2)
					TXS	;Set Stack Pointer (2)
;
					JSR	INIT_PG03	;Xfer default Vectors/HW Config to $0300 (6)
					JSR	INIT_IO	;Init I/O - Console, Timers, Ports (6)
;
; Send BIOS init msg to console
;	- note: X reg is zero on return from INIT_IO
BMSG_LP		LDA	BIOS_MSG,X	;Get BIOS init msg (4)
					BEQ	CMBV	;If zero, msg done, goto cold start monitor (2/3)
					JSR	CHROUT	;Send to console (6)
					INX	;Increment Index (2)
					BRA	BMSG_LP	;Loop back until done (3)
;
IRQ_VECTOR	;This is the ROM start for the BRK/IRQ handler
					PHA	;Save A Reg (3)
					PHX	;Save X Reg (3)
					PHY	;Save Y Reg (3)
					TSX	;Get Stack pointer (2)
					LDA	$0100+4,X	;Get Status Register (4)
					AND	#$10	;Mask for BRK bit set (2)
					BNE	DO_BRK	;If set, handle BRK (2/3)
					JMP	(IRQVEC0)	;Jump to Soft vectored IRQ Handler (5) (24 clock cycles to vector routine)
DO_BRK		JMP	(BRKVEC0)	;Jump to Soft vectored BRK Handler (5) (25 clock cycles to vector routine)
;
IRQ_EXIT0	;This is the standard return for the IRQ/BRK handler routines
					PLY	;Restore Y Reg (4)
					PLX	;Restore X Reg (4)
					PLA	;Restore A Reg (4)
					RTI	;Return from IRQ/BRK routine (6) (18 clock cycles from vector jump to IRQ end)
;
;******************************************************************************
;
;START OF BIOS DEFAULT VECTOR DATA AND HARDWARE CONFIGURATION DATA
;
;The default location for the NMI/BRK/IRQ Vector data is at location $0400
; details of the layout are listed at the top of the source file
;	there are 8 main vectors and 8 vector inserts, one is used for the 6522
;
;The default location for the hardware configuration data is at location $0420
; it is mostly a freeform table which gets copied from ROM to page $04
; the default size for the config table is 32 bytes, 17 bytes are free
;
VEC_TABLE	;Vector table data for default ROM handlers
;Vector set 0
					.WORD	NMI_VECTOR	;NMI Location in ROM
					.WORD	BRKINSTR0	;BRK Location in ROM
					.WORD	INTERUPT1	;IRQ Location in ROM
;
					.WORD	WRM_MON	;NMI return handler in ROM
					.WORD	WRM_MON	;BRK return handler in ROM
					.WORD	IRQ_EXIT0	;IRQ return handler in ROM
;
					.WORD	MONITOR	;Monitor Cold start
					.WORD	WRM_MON	;Monitor Warm start
;
;Vector Inserts (total of 8)
; these can be used as required, one is used by default for the 6522
; as NMI/BRK/IRQ and the Monitor are vectored, all can be extended
; by using these reserved vectors. 
					.WORD	INTERUPT0	;Insert 0 Location - for 6522 timer1
					.WORD	INTERUPT0	;Insert 1 Location - for 6522 timer2
					.WORD	$FFFF	;Insert 2 Location
					.WORD	$FFFF	;Insert 3 Location
					.WORD	$FFFF	;Insert 4 Location
					.WORD	$FFFF	;Insert 5 Location
					.WORD	$FFFF	;Insert 6 Location
					.WORD	$FFFF	;Insert 7 Location
;
CFG_TABLE	;Configuration table for hardware devices
;
CFG_6551	;2 bytes required for 6551
; Command Register bit definitions:
; Bit 7/6	= Parity Control: 0,0 = Odd Parity
; Bit 5		= Parity enable: 0 = No Parity
; Bit 4		= Receiver Echo mode: 0 = Normal 
; Bit 3/2	= Transmitter Interrupt Control: 
; Bit 1		= Receiver Interrupt Control: 0 = Enabled / 1 = Disabled
; Bit 0		= DTR Control: 1 = DTR Ready
;
; Default for setup:		%00001001 ($09)
; Default for transmit:	%00000101 ($05)
					.BYTE	$09	;Default 65C51 Command register, transmit/receiver IRQ output enabled)
;
; Baud Select Register:
; Bit 7		= Stop Bit: 0 = 1 Stop Bit
; Bit 6/5	= Word Length: 00 = 8 bits
; Bit 4		= Receiver Clock Source: 0 = External Clk 1 = Baud Rate Gen
; Bit 3-0	= Baud Rate Table: 1111 = 19.2K Baud (default)
;
; Default for setup:		%00011111 ($1F) - 19.2K, 8 data, 1 stop)
					.BYTE	$10	;Default 65C51 Control register, (115.2K,no parity,8 data bits,1 stop bit)
;
CFG_6522	;13 bytes required for 6522
;Timer 1 load value is based on CPU clock frequency for 4 milliseconds - RTC use
; Note that 2 needs to be subtracted from the count value, i.e., 16000 needs to be 15998, etc.
; This corresponds to the W65C22 datasheet showing N+2 between interrupts in continuous mode
; 16MHz = 63998, 10MHz = 39998, 8MHz = 31998, 6MHz = 23998, 5MHz = 19998, 4MHz = 15998, 2MHz = 7998
; 16MHz = $F9FE, 10MHz = $9C3E, 8MHz = $7CFE, 6MHz = $5DBE, 5MHz = $4E1E, 4MHz = $3E7E, 2MHz = $1F3E
;
;Timer 2 load value is based on CPU clock frequency for 1 millisecond - delay use
;	- Timer 2 value needs to be adjusted to compensate for the time to respond to the interrupt
;	- and reset the timer for another 1ms countdown, which is 55 clock cycles
;	- As Timer 2 counts clock cycles, each of the values should be adjusted by subtracting 55+2
;	16MHz = 15943,	10MHz = 9943,		8MHz = 7943,	6MHz = 5943,	5MHz = 4943,	4MHz = 3943,	2MHz = 1943
; 16MHz = $3E47,	10MHz = $26D7,	8MHz = $1F07,	6MHz = $1737,	5MHz = $134F,	4MHz = $0F67,	2MHz = $0797
;
; only the ports that are needed for config are shown below:
;
					.BYTE	$00	;Data Direction register Port B
					.BYTE	$00	;Data Direction register Port A
					.BYTE	$FE	;T1CL - set for CPU clock as above - $04
					.BYTE	$7C	;T1CH - to 4ms (250 interupts per second) - $05
					.BYTE	$00	;T1LL - T1 counter latch low
					.BYTE	$00	;T1LH - T1 counter latch high
					.BYTE	$07	;T2CL - T2 counter low count - set for 1ms (adjusted)
					.BYTE	$1F	;T2CH - T2 counter high count - used for delay timer
					.BYTE	$00	;SR - Shift register
					.BYTE	$40	;ACR - Aux control register
					.BYTE	$01	;PCR - Peripheral control register
					.BYTE	$7F	;IFR - Interrupt flag register (clear all)
					.BYTE	$E2	;IER - Interrupt enable register (enable T1/T2)
					.BYTE	$FF	;Free config byte
;
;Reserved for additional I/O devices (16 bytes total)
					.BYTE	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
					.BYTE	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
;
;END OF BIOS VECTOR DATA AND HARDWARE DEFAULT CONFIGURATION DATA
;******************************************************************************
;
;******************************************************************************
;BIOS init message - sent before jumping to the monitor coldstart vector
;******************************************************************************
BIOS_MSG	.BYTE	$0D,$0A
					.BYTE	"BIOS 1.4 "
					.BYTE	"8MHz"
					.BYTE	$00	;Terminate string

.segment "VECTORS"
;******************************************************************************
; $FFFA	; 65C02 Vector Table
;******************************************************************************
					.WORD	NMIVEC0	;NMI
					.WORD	COLDSTRT	;RESET
					.WORD	IRQ_VECTOR	;IRQ