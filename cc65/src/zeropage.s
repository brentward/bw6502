; ; zero page use
; ; Generic User Registers
; r0              = $E2   ; 2 bytes
; r0L             = $E2   ; low byte
; r0H             = $E3   ; high byte
; r1              = $E4   ; 2 bytes
; r1L             = $E4   ; low byte
; r1H             = $E5   ; high byte
; r2              = $E6   ; 2 bytes
; r2L             = $E6   ; low byte
; r2H             = $E7   ; high byte
; r3              = $E8   ; 2 bytes
; r3L             = $E8   ; low byte
; r3H             = $E9   ; high byte
; ; OS Variables
; lcd_addr        = $EA   ; 1 byte, lcd busy flag and address
; kb_wptr         = $EB   ; 1 byte, offset in keyboard buffer to write to
; kb_rptr         = $EC   ; 1 byte, offset in keyboard buffer to read from
; kb_flags        = $ED   ; 1 byte
; kb_modifiers    = $EE   ; 1 byte
