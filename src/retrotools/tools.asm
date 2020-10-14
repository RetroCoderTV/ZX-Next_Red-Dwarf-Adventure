;MACROS
	MACRO BREAKPOINT 
		DW $01DD 
	ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wait for n clock cycles
;; Inputs: BC=n
;; Outputs: none
;; Destroys: A,BC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wait:
	dec bc
	ld a,b
	cp 0
	jp nz, wait
	ret



;;;em00k wrote this;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Wait for vertical blank
;; Inputs: B=frames delay count
;; Outputs: 
;; Destroys: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
WaitRasterLine:
	call RastererWait
	djnz WaitRasterLine
	ret
RastererWait: 
	push bc 
	ld e,190 : ld a,$1f : ld bc,$243b : out (c),a : inc b 
WaitForLinea: 
	in a,(c) : cp e : jr nz,WaitForLinea 
	pop bc 
	ret











LAYER2_ACCESS_PORT	EQU 	$123B

		;----------------
		; Original code by Michael Ware adjustd to work with ZXB
		; Plot tile to layer 2 (needs to accept > 256 tiles)
		; in - hl = y/x tile coordinate (0-17, 0-31)
		; in - a = number of tile to display
		;----------------
PlotTile8:
		ld d,64
		ld e,a					; 11
		mul					

		ld a,%11000000 			; this points to $c000 
		or d		 			; 8
		ex de,hl				; 4			; cannot avoid an ex (de now = yx)
		ld h,a					; 4
		ld a,e
		rlca
		rlca
		rlca
		ld e,a					; 4+4+4+4+4 = 20	; mul x,8
		ld a,d
		rlca
		rlca
		rlca
		ld d,a					; 4+4+4+4+4 = 20	; mul y,8
		and 192
		or 3					; or 3 to keep layer on				; 8
		ld bc,LAYER2_ACCESS_PORT
		out (c),a      ; 21			; select bank

		ld a,d
		and 63
		ld d,a					; clear top 2 bits of y (dest) (4+4+4 = 12)
		; T96 here
		ld a,8					; 7
.plotTilesLoop2:
		push de					; 11
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi
		ldi					; 8 * 16 = 128
		
		pop de					; 11
		inc d					; 4 add 256 for next line down
		dec a					; 4
		jr nz,.plotTilesLoop2			; 12/7
		ret 







