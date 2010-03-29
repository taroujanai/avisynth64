;=============================================================================
; Function declarations
;=============================================================================
%ASSIGN y 1
%REP 16

	global FRH_yv12_aligned_FIR %+ y
	global FRH_yv12_unaligned_FIR %+ y

%ASSIGN y y+1
%ENDREP
	
	
;=============================================================================
; Read only data
;=============================================================================
SECTION .rodata align=16
FPRoundMMX:
	dq 00000200000002000h
	dq 00000200000002000h
MaskWLow:
	dq 00000000000FF00FFh
MaskDW:
	dq 0FFFF0000FFFF0000h
MaskA:
	dq 000000000FF000000h

;=============================================================================
; void FRH_yv12_<memtype>_<firsize>(BYTE* srcp, BYTE* dstp, int src_pitch, int dst_pitch, int dst_height, int dst_width, int orig_width, int* pattern_array)
;=============================================================================
%MACRO FRH_yv12_memtpye_firsize 2
align 16
PROC_FRAME FRH_yv12_ %+ %1 %+ _FIR %+ %2
	push rsi
	[pushreg rsi]
	push rbp
	[pushreg rbx]
	push r12
	[pushreg r12]
	push r13
	[pushreg r13]
	push r14
	[pushreg r14]
	push r15
	[pushreg r15]
END_PROLOG

%DEFINE .dst_height [rsp+48+40]
%DEFINE .dst_width [rsp+48+48]
%DEFINE .orig_width [rsp+48+56]
%DEFINE .pattern_array [rsp+48+64]

	;load constants
	pxor			xmm5, xmm5		
	movq			mm6, [rel FPRoundMMX]
	mov				r15, QWORD .pattern_array		; pattern_luma, pattern_chroma
	add				r15, 8

	;load the y counter
	mov				esi, DWORD .dst_height

align 16	
.yv_yloop:
	mov				ebp, .dst_width					; set the x counter 
	shr				ebp, 2							; x = dst_width / 4
	mov				r14, r15						; curr_luma=array+2
	mov				r10d, DWORD [r14]				; Temporary pointer to Y plane filter-->DWORD @ mem[curr_luma[0]]
	mov				r12, rcx						; Save a copy of the srcp for destruction
	mov				r11d, DWORD .orig_width			; Source width is used to copy pixels to a workspace
	xor				rax, rax	

align 16
.yv_deintloop:
	prefetchnta		[r12+64]
	prefetchnta		[r10+rax+128]
	%IFIDNI %1,aligned
	movdqa			xmm0, DQWORD [r12+ 0]				; xmm0 = 16xYY
	movdqa			xmm2, DQWORD [r12+16]				; xmm0 = 16xYY
	%ELSE
	lddqu			xmm0, DQWORD [r12+ 0]				; xmm0 = 16xYY
	lddqu			xmm2, DQWORD [r12+16]				; xmm0 = 16xYY
	%ENDIF
	
	punpckhbw		xmm1, xmm0						; xmm1 = (Y0 Y0 Y0 Y0) x4
	punpcklbw		xmm0, xmm5						; xmm0 = (0Y 0Y 0Y 0Y) x4
	psrlw			xmm1, 8							; xmm1 = (0Y 0Y 0Y 0Y) x4
	punpckhbw		xmm3, xmm2						; xmm1 = (Y0 Y0 Y0 Y0) x4
	punpcklbw		xmm2, xmm5						; xmm0 = (0Y 0Y 0Y 0Y) x4
	psrlw			xmm3, 8							; xmm1 = (0Y 0Y 0Y 0Y) x4
	movdqa			[r10+rax], xmm0					; store base words
	movdqa			[r10+rax+16], xmm1				; store +16 words
	movdqa			[r10+rax+32], xmm2				; store +32 words
	movdqa			[r10+rax+48], xmm3				; store +64 words 
	add				eax, 64							; offset+=32, we just stored 32 bytes of info
	add				r12d, 32						; srcp = next 16 bytes
	sub				r11d, 32						; width-=16 to account for bytes we just moved and unpacked
	ja				.yv_deintloop					; if not mod 16, could give mem access errors?
													; further investigation is needed on above point
	mov				rax, rdx						; copy the dstp for inner loop  

align 16
.yv_xloop:
	mov				r10d, DWORD [r14]				; r10 = &tempY[ofs0]
	mov				r12d, DWORD [r14+(%2*8+8)]		; r12 = next &tempY[ofs1]
	movq			mm1, mm6						; start with rounder 
	movq			mm3, mm6						; start with rounder
	mov				r11d, DWORD [r14+4]				; r11 = &tempY[ofs1]
	mov				r13d, DWORD [r14+(%2*8+8)+4]	; r13 = next &tempY[ofs1]
	add				r14, 8							; cur_luma++

	%REP %2
	movd			mm2, [r10]						; mm2 =  0| 0|Yb|Ya
	movd			mm4, [r12]
	punpckldq		mm2, [r11]						; mm2 = Yn|Ym|Yb|Ya
	add				r10, 4
	add				r12, 4
	pmaddwd			mm2, [r14]						; mm2 = Y1|Y0 (DWORDs)
	punpckldq		mm4, [r13]						; [r14] = COn|COm|COb|COa
	add				r11, 4
	add				r13, 4
	pmaddwd			mm4, [r14+(%2*8+8)]				; mm4 = Y1|Y0 (DWORDs)
	add				r14, 8							; cur_luma++
	paddd			mm1, mm2						; accumulate
	paddd			mm3, mm4						; accumulate
	%ENDREP
	
	add				r14, (%2*8+8)					; curr_luma += filter_offset
	psrad			mm1, 14							; mm1 = --y1|--y0
	psrad			mm3, 14							; mm3 = --y3|--y2
	packssdw		mm1, mm3						; mm1 = -3|-2|-1|-0
	packuswb		mm1, mm1						; mm1 = 3|2|1|0 3|2|1|0
	movd			[rax], mm1
	add				eax, 4
	sub				ebp, 1
	ja				.yv_xloop

.endyloop:
	add				rcx, r8							; srcp+=src_pitch
	add				rdx, r9							; dstp+=dst_pitch
	sub				esi, 1
	ja				.yv_yloop

.endfunc:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	pop rsi
	emms
%ENDMACRO

;=============================================================================
; void FRH_yv12_<memtype>_<firsize>(BYTE* srcp, BYTE* dstp, int src_pitch, int dst_pitch, int dst_height, int dst_width, int orig_width, int* pattern_array)
;=============================================================================
%MACRO FRH_yv12_memtpye_firsize_new 2
align 16
PROC_FRAME FRH_yv12_ %+ %1 %+ _FIR %+ %2
	push rsi
	[pushreg rsi]
	push rbp
	[pushreg rbx]
	push r12
	[pushreg r12]
	push r13
	[pushreg r13]
	push r14
	[pushreg r14]
	push r15
	[pushreg r15]
END_PROLOG

%DEFINE .dst_height [rsp+48+40]
%DEFINE .dst_width [rsp+48+48]
%DEFINE .orig_width [rsp+48+56]
%DEFINE .pattern_array [rsp+48+64]

	;load constants
	pxor			xmm5, xmm5		
	movdqa			xmm6, [rel FPRoundMMX]
	mov				r15, QWORD .pattern_array		; pattern_luma, pattern_chroma
	add				r15, 8

	;load the y counter
	mov				esi, DWORD .dst_height

align 16	
.yv_yloop:
	mov				ebp, .dst_width					; set the x counter 
	shr				ebp, 2							; x = dst_width / 4
	mov				r14, r15						; curr_luma=array+2
	mov				r10d, DWORD [r14]				; Temporary pointer to Y plane filter-->DWORD @ mem[curr_luma[0]]
	mov				r12, rcx						; Save a copy of the srcp for destruction
	mov				r11d, DWORD .orig_width			; Source width is used to copy pixels to a workspace
	xor				rax, rax	

align 16
.yv_deintloop:
	prefetchnta		[r12+64]
	prefetchnta		[r10+rax+128]
	%IFIDNI %1,aligned
	movdqa			xmm0, DQWORD [r12+ 0]				; xmm0 = 16xYY
	movdqa			xmm2, DQWORD [r12+16]				; xmm0 = 16xYY
	%ELSE
	movdqu			xmm0, DQWORD [r12+ 0]				; xmm0 = 16xYY
	movdqu			xmm2, DQWORD [r12+16]				; xmm0 = 16xYY
	%ENDIF
	
	punpckhbw		xmm1, xmm0						; xmm1 = (Y0 Y0 Y0 Y0) x4
	punpcklbw		xmm0, xmm5						; xmm0 = (0Y 0Y 0Y 0Y) x4
	psrlw			xmm1, 8							; xmm1 = (0Y 0Y 0Y 0Y) x4
	punpckhbw		xmm3, xmm2						; xmm1 = (Y0 Y0 Y0 Y0) x4
	punpcklbw		xmm2, xmm5						; xmm0 = (0Y 0Y 0Y 0Y) x4
	psrlw			xmm3, 8							; xmm1 = (0Y 0Y 0Y 0Y) x4
	movdqa			[r10+rax], xmm0					; store base words
	movdqa			[r10+rax+16], xmm1				; store +16 words
	movdqa			[r10+rax+32], xmm2				; store +32 words
	movdqa			[r10+rax+48], xmm3				; store +64 words 
	add				eax, 64							; offset+=64, we just stored 32 bytes of info
	add				r12d, 32						; srcp = next 32 bytes
	sub				r11d, 32						; width-=32 to account for bytes we just moved and unpacked
	ja				.yv_deintloop					; if not mod 16, could give mem access errors?
													; further investigation is needed on above point
	mov				rax, rdx						; copy the dstp for inner loop  

align 16
.yv_xloop:
	mov				r10d, DWORD [r14]				; r10 = &tempY[ofs0]
	mov				r12d, DWORD [r14+(%2*8+8)]		; r12 = next &tempY[ofs1]
	movdqa			xmm1, xmm6						; start with rounder 
	movdqa			xmm3, xmm6						; start with rounder
	mov				r11d, DWORD [r14+4]				; r11 = &tempY[ofs1]
	mov				r13d, DWORD [r14+(%2*8+8)+4]	; r13 = next &tempY[ofs1]
	add				r14, 8							; cur_luma++

	%REP (%2/2)
	movq			xmm2, [r10]						; mm2 =  0| 0|Yb|Ya
	movq			xmm4, [r12]
	add				r10, 16
	add				r12, 16
	movq			xmm7, [r11]
	movq			xmm8, [r13]
	add				r11, 16
	add				r13, 16
	punpckldq		xmm2, xmm7						; mm2 = Yn|Ym|Yb|Ya
	punpckldq		xmm4, xmm8						; [r14] = COn|COm|COb|COa
	movdqu			xmm7, [r14]
	movdqu			xmm8, [r14+(%2*8+8)]
	
	pmaddwd			xmm2, xmm7						; mm2 = Y1|Y0 (DWORDs)
	pmaddwd			xmm4, xmm8						; mm4 = Y1|Y0 (DWORDs)
	
	add				r14, 16							; cur_luma++
	paddd			xmm1, xmm2						; accumulate
	paddd			xmm3, xmm4						; accumulate
	%ENDREP
	
	%IF (%2 % 2 == 1)
	movd			xmm2, [r10]						; mm2 =  0| 0|Yb|Ya
	movd			xmm4, [r12]
	movd			xmm7, [r11]
	add				r10, 8
	add				r12, 8
	punpckldq		xmm2, xmm7						; mm2 = Yn|Ym|Yb|Ya
	movq			xmm7,[r14]
	pshufd			xmm7,xmm7,044h
	pmaddwd			xmm2, xmm7						; mm2 = Y1|Y0 (DWORDs)
	movd			xmm7, [r13]
	punpckldq		xmm4, xmm7						; [r14] = COn|COm|COb|COa
	add				r11, 8
	add				r13, 8
	movq			xmm7, [r14+(%2*8+8)]
	pshufd			xmm7,xmm7,044h	
	pmaddwd			xmm4, xmm7						; mm4 = Y1|Y0 (DWORDs)
	add				r14, 8							; cur_luma++
	paddd			xmm1, xmm2						; accumulate
	paddd			xmm3, xmm4						; accumulate
	%ENDIF
	
	add				r14, (%2*8+8)					; curr_luma += filter_offset
	psrad			xmm1, 14							; mm1 = --y1|--y0
	psrad			xmm3, 14							; mm3 = --y3|--y2
	packssdw		xmm1, xmm3						; mm1 = -3|-2|-1|-0
	packuswb		xmm1, xmm1						; mm1 = 3|2|1|0 3|2|1|0
	movq			[rax], xmm1
	add				eax, 8
	sub				ebp, 2
	ja				.yv_xloop

.endyloop:
	add				rcx, r8							; srcp+=src_pitch
	add				rdx, r9							; dstp+=dst_pitch
	sub				esi, 1
	ja				.yv_yloop

.endfunc:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	pop rsi
	emms
%ENDMACRO

	
;=============================================================================
; Instantiation of macros (yasm doesn't like ret in a macro when using PROC_FRAME)
;=============================================================================
section .text
%ASSIGN y 1
%REP 3

FRH_yv12_memtpye_firsize aligned,y
ret
ENDPROC_FRAME

FRH_yv12_memtpye_firsize unaligned,y
ret
ENDPROC_FRAME

%ASSIGN y y+1
%ENDREP

%REP 13

FRH_yv12_memtpye_firsize aligned,y
ret
ENDPROC_FRAME

FRH_yv12_memtpye_firsize unaligned,y
ret
ENDPROC_FRAME

%ASSIGN y y+1
%ENDREP

