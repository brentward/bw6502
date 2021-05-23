.zeropage

ZPSTART         = $00        ; Start of zero page workspace
;
LAB_WARM        = ZPSTART    ; $00=BASIC warm start entry point
Wrmjpl          = LAB_WARM+1 ; BASIC warm start vector jump low byte
Wrmjph          = LAB_WARM+2 ; BASIC warm start vector jump high byte

Usrjmp          = Wrmjph+1   ; USR function JMP address
Usrjpl          = Usrjmp+1   ; USR function JMP vector low byte
Usrjph          = Usrjmp+2   ; USR function JMP vector high byte

Nullct          = Usrjph+1   ; nulls output after each line
TPos            = Nullct+1   ; BASIC terminal position byte
TWidth          = TPos+1     ; BASIC terminal width byte
Iclim           = TWidth+1   ; input column limit
Itempl          = Iclim+1    ; temporary integer low byte
Itemph          = Itempl+1   ; temporary integer high byte

nums_1          = Itempl     ; number to bin/hex string convert MSB
nums_2          = nums_1+1   ; number to bin/hex string convert
nums_3          = nums_1+2   ; number to bin/hex string convert LSB

Srchc           = nums_3+1   ; search character
Temp3           = Srchc      ; temp byte used in number routines
Scnquo          = Srchc+1    ; scan-between-quotes flag
Asrch           = Scnquo     ; alt search character

XOAw_l          = Srchc      ; eXclusive OR, OR and AND word low byte
XOAw_h          = Scnquo     ; eXclusive OR, OR and AND word high byte

Ibptr           = Scnquo+1   ; input buffer pointer
Dimcnt          = Ibptr      ; # of dimensions
Tindx           = Ibptr      ; token index

Defdim          = Ibptr+1    ; default DIM flag
Dtypef          = Defdim+1   ; data type flag, $FF=string, $00=numeric
Oquote          = Dtypef+1   ; open quote flag (b7) (Flag: DATA scan; LIST quote; memory)
Gclctd          = Oquote     ; garbage collected flag
Sufnxf          = Gclctd+1   ; subscript/FNX flag, 1xxx xxx = FN(0xxx xxx)
Imode           = Sufnxf+1   ; input mode flag, $00=INPUT, $80=READ

Cflag           = Imode+1    ; comparison evaluation flag

TabSiz          = Cflag+1    ; TAB step size (was input flag)

next_s          = TabSiz+1   ; next descriptor stack address

; these two bytes form a word pointer to the item
; currently on top of the descriptor stack

last_sl         = next_s+1   ; last descriptor stack address low byte
last_sh         = last_sl+1  ; last descriptor stack address high byte (always $00)

des_sk          = last_sh+1  ; descriptor stack start address (temp strings)

ut1_pl          = des_sk+9   ; utility pointer 1 low byte
ut1_ph          = ut1_pl+1   ; utility pointer 1 high byte
ut2_pl          = ut1_ph+1   ; utility pointer 2 low byte
ut2_ph          = ut2_pl+1   ; utility pointer 2 high byte

Temp_2          = ut1_pl     ; temp byte for block move

FACt_1          = ut2_ph+1   ; FAC temp mantissa1
FACt_2          = FACt_1+1   ; FAC temp mantissa2
FACt_3          = FACt_2+1   ; FAC temp mantissa3

dims_l          = FACt_2     ; array dimension size low byte
dims_h          = FACt_3     ; array dimension size high byte

TempB           = FACt_1+3   ; temp page 0 byte

Smeml           = TempB+1    ; start of mem low byte         (Start-of-Basic)
Smemh           = Smeml+1    ; start of mem high byte        (Start-of-Basic)
Svarl           = Smemh+1    ; start of vars low byte        (Start-of-Variables)
Svarh           = Svarl+1    ; start of vars high byte       (Start-of-Variables)
Sarryl          = Svarh+1    ; var mem end low byte          (Start-of-Arrays)
Sarryh          = Sarryl+1   ; var mem end high byte         (Start-of-Arrays)
Earryl          = Sarryh+1   ; array mem end low byte        (End-of-Arrays)
Earryh          = Earryl+1   ; array mem end high byte       (End-of-Arrays)
Sstorl          = Earryh+1   ; string storage low byte       (String storage (moving down))
Sstorh          = Sstorl+1   ; string storage high byte      (String storage (moving down))
Sutill          = Sstorh+1   ; string utility ptr low byte
Sutilh          = Sutill+1   ; string utility ptr high byte
Ememl           = Sutilh+1   ; end of mem low byte           (Limit-of-memory)
Ememh           = Ememl+1    ; end of mem high byte          (Limit-of-memory)
Clinel          = Ememh+1    ; current line low byte         (Basic line number)
Clineh          = Clinel+1   ; current line high byte        (Basic line number)
Blinel          = Clineh+1   ; break line low byte           (Previous Basic line number)
Blineh          = Blinel+1   ; break line high byte          (Previous Basic line number)

Cpntrl          = Blineh+1   ; continue pointer low byte
Cpntrh          = Cpntrl+1   ; continue pointer high byte

Dlinel          = Cpntrh+1   ; current DATA line low byte
Dlineh          = Dlinel+1   ; current DATA line high byte

Dptrl           = Dlineh+1   ; DATA pointer low byte
Dptrh           = Dptrl+1    ; DATA pointer high byte

Rdptrl          = Dptrh+1    ; read pointer low byte
Rdptrh          = Rdptrl+1   ; read pointer high byte

Varnm1          = Rdptrh+1   ; current var name 1st byte
Varnm2          = Varnm1+1   ; current var name 2nd byte

Cvaral          = Varnm2+1   ; current var address low byte
Cvarah          = Cvaral+1   ; current var address high byte

Frnxtl          = Cvarah+1   ; var pointer for FOR/NEXT low byte
Frnxth          = Frnxtl+1   ; var pointer for FOR/NEXT high byte

Tidx1           = Frnxtl     ; temp line index

Lvarpl          = Frnxtl     ; let var pointer low byte
Lvarph          = Frnxth     ; let var pointer high byte

prstk           = Frnxtl+2   ; precedence stacked flag

comp_f          = prstk+2    ; compare function flag, bits 0,1 and 2 used
                                ; bit 2 set if >
                                ; bit 1 set if =
                                ; bit 0 set if <

func_l          = comp_f+1   ; function pointer low byte
func_h          = func_l+1   ; function pointer high byte

garb_l          = func_l     ; garbage collection working pointer low byte
garb_h          = func_h     ; garbage collection working pointer high byte

des_2l          = func_h+1   ; string descriptor_2 pointer low byte
des_2h          = des_2l+1   ; string descriptor_2 pointer high byte

g_step          = des_2l+2   ; garbage collect step size

Fnxjmp          = g_step+1   ; jump vector for functions
Fnxjpl          = Fnxjmp+1   ; functions jump vector low byte
Fnxjph          = Fnxjmp+2   ; functions jump vector high byte

g_indx          = Fnxjpl     ; garbage collect temp index

FAC2_r          = Fnxjmp+2   ; FAC2 rounding byte

Adatal          = FAC2_r+1   ; array data pointer low byte
Adatah          = Adatal+1   ; array data pointer high byte

Nbendl          = Adatal     ; new block end pointer low byte
Nbendh          = Adatah     ; new block end pointer high byte

Obendl          = Adatah+1   ; old block end pointer low byte
Obendh          = Obendl+1   ; old block end pointer high byte

numexp          = Obendh+1   ; string to float number exponent count
expcnt          = numexp+1   ; string to float exponent count

numbit          = numexp     ; bit count for array element calculations

numdpf          = expcnt+1   ; string to float decimal point flag
expneg          = numdpf+1   ; string to float eval exponent -ve flag

Astrtl          = numdpf     ; array start pointer low byte
Astrth          = expneg     ; array start pointer high byte

Histrl          = numdpf     ; highest string low byte
Histrh          = expneg     ; highest string high byte

Baslnl          = numdpf     ; BASIC search line pointer low byte
Baslnh          = expneg     ; BASIC search line pointer high byte

Fvar_l          = numdpf     ; find/found variable pointer low byte
Fvar_h          = expneg     ; find/found variable pointer high byte

Ostrtl          = numdpf     ; old block start pointer low byte
Ostrth          = expneg     ; old block start pointer high byte

Vrschl          = numdpf     ; variable search pointer low byte
Vrschh          = expneg     ; variable search pointer high byte

FAC1_e          = expneg+1   ; FAC1 exponent
FAC1_1          = FAC1_e+1   ; FAC1 mantissa1
FAC1_2          = FAC1_e+2   ; FAC1 mantissa2
FAC1_3          = FAC1_e+3   ; FAC1 mantissa3
FAC1_s          = FAC1_e+4   ; FAC1 sign (b7)

str_ln          = FAC1_e     ; string length
str_pl          = FAC1_1     ; string pointer low byte
str_ph          = FAC1_2     ; string pointer high byte

des_pl          = FAC1_2     ; string descriptor pointer low byte
des_ph          = FAC1_3     ; string descriptor pointer high byte

mids_l          = FAC1_3     ; MID$ string temp length byte

negnum          = FAC1_e+5   ; string to float eval -ve flag
numcon          = negnum     ; series evaluation constant count

FAC1_o          = negnum+1   ; FAC1 overflow byte

FAC2_e          = FAC1_o+1   ; FAC2 exponent
FAC2_1          = FAC2_e+1   ; FAC2 mantissa1
FAC2_2          = FAC2_e+2   ; FAC2 mantissa2
FAC2_3          = FAC2_e+3   ; FAC2 mantissa3
FAC2_s          = FAC2_e+4   ; FAC2 sign (b7)

FAC_sc          = FAC2_e+5   ; FAC sign comparison, Acc#1 vs #2
FAC1_r          = FAC_sc+1   ; FAC1 rounding byte

ssptr_l         = FAC_sc     ; string start pointer low byte
ssptr_h         = FAC1_r     ; string start pointer high byte

sdescr          = FAC_sc     ; string descriptor pointer

csidx           = FAC1_r+1   ; line crunch save index
Asptl           = csidx      ; array size/pointer low byte
Aspth           = csidx+1    ; array size/pointer high byte

Btmpl           = Asptl      ; BASIC pointer temp low byte
Btmph           = Aspth      ; BASIC pointer temp low byte

Cptrl           = Asptl      ; BASIC pointer temp low byte
Cptrh           = Aspth      ; BASIC pointer temp low byte

Sendl           = Asptl      ; BASIC pointer temp low byte
Sendh           = Aspth      ; BASIC pointer temp low byte
;
; CHRGET/CHRGOT routine now located in ROM
; The two pointers below are accessed via ROM
; Reduces Page zero usage by quite a bit with a minor performance penalty
; CMOS addressing mode used, saves memory and execution time
;
Bpntrl          = Sendh+1    ; BASIC execute (get byte) pointer low byte
Bpntrh          = Bpntrl+1   ; BASIC execute (get byte) pointer high byte

Rbyte4          = Bpntrh+1   ; extra PRNG byte

Rbyte1          = Rbyte4+1   ; most significant PRNG byte
Rbyte2          = Rbyte4+2   ; middle PRNG byte
Rbyte3          = Rbyte4+3   ; least significant PRNG byte

Decss           = Rbyte3+1   ; number to decimal string start
Decssp1         = Decss+1    ; number to decimal string start
ZPLastByte      = Decss+17   ; last declared byte in Page Zero

; Note: C02BIOS uses Page Zero locations from $E0 - $FF
; C02Monitor uses Page Zero locations from $B0 - $DF
lcd_addr		= $E2	; 1 byte, lcd busy flag and address
in_cnt			= $E3	; 1 byte
in_tail			= $E4	; 1 byte
kb_flags		= $E5	; 1 byte
kb_modifiers 	= $E6	; 1 byte
r0				= $E8	; 2 bytes
r0L				= $E8	; low byte
r0H				= $E9	; high byte
r1				= $EA	; 2 bytes
r1L				= $EA	; low byte
r1H				= $EB	; high byte
r2				= $EC	; 2 bytes
r2L				= $EC	; low byte
r2H				= $ED	; high byte
in_head			= $EE		; unused
; IHEAD			      = $EF	;input buffer head pointer
; ITAIL			      = $F0	;input buffer tail pointer
; OCNT			      = $F1	;output buffer count
; OHEAD			      = $F2	;output buffer head pointer
; OTAIL			      = $F4	;output buffer tail pointer

; add page zero variables for Xmodem transfer using the C02 Monitor routines

PGZERO_ST       = $B0               ; Start of Page Zero usage (C02 Monitor)

PROMPTL         = PGZERO_ST+22      ; Prompt string address
PROMPTH         = PGZERO_ST+23
SRCL            = PGZERO_ST+24      ; Source address for memory operations
SRCH            = PGZERO_ST+25
TGTL            = PGZERO_ST+26      ; Target address for memory operations
TGTH            = PGZERO_ST+27
LENL            = PGZERO_ST+28      ; Length address for memory operations
LENH            = PGZERO_ST+29

OPXMDM          = PGZERO_ST+38      ; Saved Opcode/Xmodem Flag variable
PTRL            = PGZERO_ST+42      ; Data pointer lo byte
PTRH            = PGZERO_ST+43      ; Data pointer hi byte
BLKNO           = PGZERO_ST+44      ; Block number
