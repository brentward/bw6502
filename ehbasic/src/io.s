in_buffer = $0400   ; 256 bytes 0x0400-0x04FF

.segment "BIOS"
io_init:
    ; stz in_tail
    ; stz in_head
    ; stz in_cnt
    ; rts
	stz in_wptr
	stz in_rptr
	rts

buf_write:  
;     ldy in_cnt
;     bmi bufful
;     ldy in_tail
;     sta in_buffer,y
;     inc in_tail
;     inc in_cnt
; bufful:
;     rts

	ldx  in_wptr        ; Start with A containing the byte to put in the buffer.
	sta  in_buffer,x    ; Get the pointer value and store the data where it says,
	inc  in_wptr        ; then increment the pointer for the next write.
	rts
 ;-------------

buf_read: 
;     clc
;     lda in_cnt
;     bne get_ch
;     rts
; get_ch:
;     phy
;     ldy in_head
;     lda in_buffer,y
;     inc in_head
;     dec in_cnt
;     ply
;     sec
;     rts
    ; clc
    jsr buf_dif
    bne get_ch
    clc
    rts
get_ch
    phy
	ldy  in_rptr        ; Ends with a containing the byte just read from buffer.
	lda  in_buffer,y    ; Eet the pointer value and read the data it points to.
	inc  in_rptr        ; Then increment the pointer for the next read.
    ply
    sec
	rts
;  ;-------------

buf_dif:
	lda in_wptr         ; Find difference between number of bytes written
	sec                 ; and how many read.
	sbc in_rptr         ; Ends with a showing the number of bytes left to read.
	rts
 ;------------- 

; ibuf			=	$0400	;INPUT BUFFER  128 BYTES - BIOS use only
; obuf			=	$0480	;OUTPUT BUFFER 128 BYTES - BIOS use only


