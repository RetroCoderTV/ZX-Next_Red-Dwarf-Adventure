;slot also specifies item type
;50=lager
;49=bazookoid
;
;



;0=world x
;1=world y
;2=position x1
;3=position x2
;4=position y1
;5=position y2
;6=attribute slot
;7=attr 2
;8=attr 3
;9=attr 4
collectables:
    db 1,0,0,0,0,16,16,50,0,%01000110,%00100000
    db 255

COLLECTABLES_DATA_LENGTH equ 10


collectables_draw:
    ld ix,collectables
collectables_drw_start:
    ld a,(ix)
    cp 255
    ret z
    cp FALSE
    jp z,collectables_drw_end

	;select slot
	ld a,(ix+6)
	ld bc, $303b ;selection of pattern
	out (c), a

	ld bc, $57 ;0x57=attribute writing port
	;attr 0 (xpos LB)
	ld a,(ix+2)
	out (c), a    

	;attr 1 (ypos LB)                                 
	ld a,(ix+4)
	out (c), a                                      

	;attr 2 (P P P P XM YM R X8/PR)
	ld a,(ix+7)
	ld b,a
	ld hl,npc_screen_x
	inc hl
	ld a,(hl)
	or b
	out (c),a

	;attr 3 (V E N5 N4 N3 N2 N1 N0 (NNNNN=Pattern ID))
	ld a,(ix+8)
	out (c),a

	;attr 4 
		;(; A. Extended Anchor Sprite
		;     H N6 T X X Y Y Y8
		; B. Relative Sprite, Composite Type
		;     0 1 N6 X X Y Y PO
		; C. Relative Sprite, Unified Type
		;     0 1 N6 0 0 0 0 PO)
	ld a,(ix+9)
	out (c),a

collectables_drw_end:
    ld de,COLLECTABLES_DATA_LENGTH
    add ix,de
    jp collectables_drw_start

	

