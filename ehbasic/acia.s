RKINSTR   PLY   ;Restore Y reg
               PLX   ;Restore X Reg
               PLA   ;Restore A Reg
               STA   ACCUM   ;Save A Reg
               STX   XREG   ;Save X Reg
               STY   YREG   ;Save Y Reg
               PLA   ;Get Processor Status           
               STA   PREG   ;Save in PROCESSOR STATUS preset/result
               TSX
               STX   SREG   ;Save STACK POINTER
               PLA   ;Pull RETURN address from STACK then save it in INDEX
               STA   INDEX   ;Low byte
               PLA
               STA   INDEXH   ;High byte
               JSR   CR2   ;Send 2 CR,LF to terminal
               JSR   PRSTAT   ;Display contents of all preset/result memory locations
               JSR   CROUT   ;Send CR,LF to terminal
               JSR   DISLINE   ;Disassemble then display instruction at address pointed to by INDEX
               LDA   #$00   ;Clear all PROCESSOR STATUS REGISTER bits
               PHA
               PLP
BREAKEY2   LDA   #$7F   ;Set STACK POINTER preset/result to $7F
               STA   SREG
               STZ   ITAIL   ;Zero out input buffer and reset pointers
               STZ   IHEAD
               STZ   ICNT
BR_NMON      BRA   NMON   ;Done interrupt service process, re-enter monitor
;
BREAKEY      PLY   ;Pull Y Reg (4)
               PLX   ;Pull X Reg (4)
               PLA   ;Pull A Reg (4)
               CLI   ;Enable IRQ (2)
               BRA   BREAKEY2   ;Finish Break Key processing (2/3)
;
;new full duplex IRQ handler
;
INTERUPT   BIT   SIOSTAT   ;xfer irq bit to n flag (4)
               BPL   REGEXT   ;if set, 6551 caused irq,(do not branch) (2/3) (7 clock cycles to regexit if not)
;
ASYNC         LDA SIOSTAT   ;get 6551 status reg (4)
               AND #%00001000   ;check receive bit (2)
               BNE RCVCHR   ;get received character (2/3) (15 clock cycles to jump to RCV)
;
               LDA SIOSTAT   ;get 6551 status reg (4)
               AND #%00010000   ;check xmit bit (2)
               BNE XMTCHR   ;send xmit character (2/3) (23 clock cycles to jump tp XMIT)
;
;no bits on means cts went high
               LDA #%00010000 ;cts high mask (2)
;
IRQEXT      STA STTVAL ;update status value (3) (31 clock cycles to here of CTS fallout)
;
REGEXT      JMP   (IRQRTVEC) ;handle old irq (5)
;
BUFFUL      LDA #%00001100 ;buffer overflow (2)
               BRA IRQEXT ;branch to exit (2/3)
;
RCVCHR      LDA SIODAT   ;get character from 6551 (4)
               BEQ   BREAKEY   ;If Break character, branch to Break Key process    (2/3)
;
RCV0         LDY ICNT   ;get buffer counter (3)
               BMI   BUFFUL   ;check against limit, branch if full (2/3)
;
               LDY ITAIL ;room in buffer (3)
               STA IBUF,Y ;store into buffer (5)
               INY ;increment tail pointer (2)
               BPL   RCV1   ;check for wraparound ($%80), branch if not (2/3)
               LDY #$00 ;else, reset pointer (2)
RCV1         STY ITAIL ;update buffer tail pointer (3)
               INC ICNT ;increment character count (5)
;   
               LDA SIOSTAT ;get 6551 status reg (4)
               AND #%00010000 ;check for xmit (2)
               BEQ REGEXT   ;exit (2/3) (41 if exit, else 40 and drop to XMT)
;
XMTCHR      LDA OCNT ;any characters to xmit? (3)
               BEQ NODATA ;no, turn off xmit (2/3)
;
OUTDAT      LDY OHEAD ;get pointer to buffer (3)
               LDA OBUF,Y ;get the next character (4)
               STA SIODAT ;send the data (4)
               INY ;increment index (2)
               BPL   OUTD1   ;check for wraparound ($80), branch if not (2/3)
               LDY #$00 ;else, reset pointer (2)
;
OUTD1         STY OHEAD ;save new head index (3)
               DEC OCNT ;decrement counter (5)
               BNE   REGEXT   ;If not zero, exit and continue normal stuff (2/3) (32 if branch, 31 if continue)
;
NODATA      LDA   #$09   ;get mask for xmit off / rcv on (2)
               STA SIOCOM ;turn off xmit irq bits (5)
               STZ OIE ; zero pointer (3)
               BRA REGEXT ;exit (3) (13 clock cycles added for turning off xmt)
;

