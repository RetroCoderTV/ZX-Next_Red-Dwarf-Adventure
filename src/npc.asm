npc_x dw 128
npc_y dw 128

NPC_ATTR_SLOT equ 61
npc_attribute_2 db %00000000
npc_attribute_3 db %11000000
npc_attribute_4 db %00100000



npc_current_type db NOT_ENABLED
NPC_MARGE equ 12
NPC_HOMER equ 13

npc_animation_counter db 0
NPC_ANIMATION_FRAME_TIME equ 12


;before calling this, set 'npc_current_type' to desired NPC type
npc_start:
	ld a,NPC_MARGE
	add a,VISIBILITY
	ld (npc_attribute_3),a
	ld a,(npc_current_type)
	cp NPC_MARGE
	ret z

	ld a,NPC_HOMER
	add a,VISIBILITY
	ld (npc_attribute_3),a
	ld a,(npc_current_type)
	cp NPC_HOMER
	ret z



	ret

npc_update:
	ld a,(npc_animation_counter)
	inc a
	ld (npc_animation_counter),a
	cp NPC_ANIMATION_FRAME_TIME
	call nc, animate_npc

	call npc_collide_player

    ret

npc_draw:
	;select slot
	ld a,NPC_ATTR_SLOT
	ld bc, $303b ;selection of pattern
	out (c), a

	ld bc, $57 ;0x57=attribute writing port
	;attr 0
	ld a,(npc_x)
	out (c), a    

	;attr 1                                  
	ld a,(npc_y)
	out (c), a                                      

	;attr 2
	ld a,(npc_attribute_2)
	ld b,a
	ld hl,npc_x
	inc hl
	ld a,(hl)
	or b
	out (c),a

	;attr 3
	ld a,(npc_attribute_3)
	out (c),a

	;attr 4
	ld a,(npc_attribute_4)
	out (c),a

	ret




animate_npc:
	call flip_npc_sprite
	xor a
	ld (npc_animation_counter),a
	ret


flip_npc_sprite:
	ld a,(npc_attribute_2)
	xor %00001000
	ld (npc_attribute_2),a
	ret




npc_collide_player:
	xor a
	call 0x229b

	ld a,(px)
	ld b,a
	ld a,(npc_x)
	add a,16 ;width
	cp b
	ret c

	ld a,(npc_x)
	ld b,a
	ld a,(px)
	add a,16 ;w
	cp b
	ret c

	ld a,(py)
	ld b,a
	ld a,(npc_y)
	add a,20 ;h + offset (standing in front of npc)
	cp b
	ret c

	ld a,(npc_y)
	ld b,a
	ld a,(py)
	add a,16
	cp b
	ret c

	ld hl,npc_x
	inc hl
	ld b,(hl)
	ld hl,px
	inc hl
	ld a,(hl)
	cp b
	ret nz

	ld hl,npc_y
	inc hl
	ld b,(hl)
	ld hl,py
	inc hl
	ld a,(hl)
	cp b
	ret nz


	;collision....
	ld a,5
	call 0x229b

	

	ret