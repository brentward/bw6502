; VIA Ports
VIA1_BASE = $0200
VIA2_BASE = $0210
VIA1_PORTB = VIA1_BASE + $0
VIA1_PORTA = VIA1_BASE + $1
VIA1_DDRB  = VIA1_BASE + $2
VIA1_DDRA  = VIA1_BASE + $3
VIA1_PRC = VIA1_BASE + $C
VIA1_IFR = VIA1_BASE + $D
VIA1_IER = VIA1_BASE + $E
VIA2_PORTB = VIA2_BASE + $0
VIA2_PORTA = VIA2_BASE + $1
VIA2_DDRB  = VIA2_BASE + $2
VIA2_DDRA  = VIA2_BASE + $3
VIA2_PRC = VIA2_BASE + $C
VIA2_IFR = VIA2_BASE + $D
VIA2_IER = VIA2_BASE + $E

; VIA Interrupt Control
VIA_INT_CA2 = $00000001
VIA_INT_CA1 = %00000010
VIA_INT_SR  = %00000100
VIA_INT_CB2 = %00001000
VIA_INT_CB1 = %00010000
VIA_INT_T2  = %00100000
VIA_INT_T1  = %01000000
VIA_INT_SET = %10000000

; VIA Peripheral Control Register
VIA_CB2_INT_LOW = %00000000
VIA_CB2_INDEPENDENT_INT_LOW = %00100000
VIA_CB2_INT_HIGH = %01000000
VIA_CB2_INDEPENDENT_INT_HIGH = %01100000
VIA_CB2_HANDSHAKE_OUT = %10000000
VIA_CB2_PULSE_OUT = %10100000
VIA_CB2_LOW_OUT = %11000000
VIA_CB2_HIGH_OUT = %11100000
VIA_CB1_INT_LOW = %00000000
VIA_CB1_INT_HIGH = %00010000
VIA_CA2_INT_LOW = %00000000
VIA_CA2_INDEPENDENT_INT_LOW = %00000010
VIA_CA2_INT_HIGH = %00000100
VIA_CA2_INDEPENDENT_INT_HIGH = %00000110
VIA_CA2_HANDSHAKE_OUT = %00001000
VIA_CA2_PULSE_OUT = %00001010
VIA_CA2_LOW_OUT = %00001100
VIA_CA2_HIGH_OUT = %00001110
VIA_CA1_INT_LOW = %00000000
VIA_CA1_INT_HIGH = %0000001

via_init:
  pha
  lda #VIA_INT_SET | VIA_INT_CA1
  sta VIA1_IER

  lda #VIA_CA1_INT_HIGH
  sta VIA1_PRC

  lda #%11111111 ; Set all pins on port B to output
  sta VIA1_DDRB
  stz VIA1_PORTB
  pla
  rts
