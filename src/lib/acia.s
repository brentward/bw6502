; ACIA Ports
ACIA_BASE = $0220
ACIA_TX_RX_DATA = ACIA_BASE + $0
ACIA_STATUS = ACIA_BASE + $1
ACIA_RESET = ACIA_BASE + $1
ACIA_COMMAND = ACIA_BASE + $2
ACIA_CONTROL: = ACIA_BASE + $3

; ACIA Status Register
ACIA_INT_ENABLE       = %10000000
ACIA_DSR_NOT_READY    = %01000000
ACIA_DCD_NOT_DETECTED = %00100000
ACIA_TX_DR_EMPTY         = %00010000
ACIA_RX_DR_FULL          = %00001000
ACIA_OVERFLOW_ERROR   = %00000100
ACIA_FRAMING_ERROR    = %00000010
ACIA_PARITY_ERROR     = %00000001

; ACIA Control Register
; Stop Bit Number (SBN) bit 7
ACIA_1_SBN = %00000000
ACIA_2_SBN = %10000000
; Word Length (WL) bits 6-5
ACIA_WL_8 = %00000000
ACIA_WL_7 = %00100000
ACIA_WL_6 = %01000000
ACIA_WL_5 = %01100000
; Receiver Clock Source (RCS) bit 4
ACIA_RX_CLOCK_EXTERNAL  = %00000000
ACIA_RX_CLOCK_BAUD_RATE = %00010000
; Selected Baud Rate (SBR) bits 3-0
ACIA_BAUD_115200   = %00000000
ACIA_BAUD_50       = %00000001
ACIA_BAUD_75       = %00000010
ACIA_BAUD_109_92   = %00000011
ACIA_BAUD_134_58   = %00000100
ACIA_BAUD_150      = %00000101
ACIA_BAUD_300      = %00000110
ACIA_BAUD_600      = %00000111
ACIA_BAUD_1200     = %00001000
ACIA_BAUD_1800     = %00001001
ACIA_BAUD_2400     = %00001010
ACIA_BAUD_3600     = %00001011
ACIA_BAUD_4800     = %00001100
ACIA_BAUD_7200     = %00001101
ACIA_BAUD_9600     = %00001110
ACIA_BAUD_19200    = %00001111

; ACIA Command Register
ACIA_NO_PARITY      = %00000000
ACIA_NO_ECHO        = %00000000
ACIA_ECHO_MODE      = %00010000
; Transmitter Interrupt Control (TIC)
ACIA_RTSB_H_TX_INT_DISABLED          = %00000000
ACIA_RTSB_L_TX_INT_DISABLED          = %00001000
ACIA_RTSB_L_TX_INT_DISABLED_TX_BREAK = %00001100
; Receiver Interrupt Request Disabled (IRD)
ACIA_RX_IRQB_DISABLED = %00000010
; Data Terminal Ready (DTR)
ACIA_DTR = %00000001

acia_init:
  stz ACIA_STATUS
  ; lda #(ACIA_1_SBN | ACIA_WL_8 | ACIA_RX_CLOCK_BAUD_RATE | ACIA_BAUD_9600)
  lda #%00011110
  sta ACIA_CONTROL

  ; lda #(ACIA_NO_PARITY | ACIA_NO_ECHO | ACIA_RTSB_L_TX_INT_DISABLED | ACIA_RX_IRQB_DISABLED| ACIA_DTR)
  lda #%00001011
  sta ACIA_COMMAND

send:
  ldx #0

send_loop:
  lda acia_text,x
  sta ACIA_TX_RX_DATA
  lda #10
  jsr wait_ms
  txa
  sbc #11
  beq send
  inx
  lda ACIA_STATUS
  lda ACIA_TX_RX_DATA
  jmp send_loop



; .write
;   ldx #0
; .next_char:
; .wait_tx_dr_empty:
;   lda ACIA_STATUS
;   ; and #ACIA_TX_DR_EMPTY
;   and #$10
;   beq .wait_tx_dr_empty
;   lda acia_text,x
;   beq .read
;   sta ACIA_TX_RX_DATA
;   inx
;   jmp .next_char

; .read:
; .wait_rx_dr_full:
;   lda ACIA_STATUS
;   ; and #ACIA_RX_DR_FULL
;   and #$08
;   beq .wait_rx_dr_full
;   lda ACIA_TX_RX_DATA
;   jmp .write

acia_text: .asciiz "Hello, Sam! "
