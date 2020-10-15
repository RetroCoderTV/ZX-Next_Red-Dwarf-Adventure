npc_screen_x dw 0x0020
npc_screen_y dw 0x0020

npc_world_x db 12    
npc_world_y db 59

NPC_ATTR_SLOT equ 30
npc_attribute_2 db %00000000
npc_attribute_3 db %11000001
npc_attribute_4 db %00100000


npc_animation_counter db 0
NPC_ANIMATION_FRAME_TIME equ 12

npc_is_showing db FALSE


;before calling this, set 'npc_current_type' to desired NPC type
npc_start:


	ret

npc_update:
	call npc_check_inview

	

	ld a,(npc_is_showing)
	cp TRUE
	ret nz

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
	ld a,(npc_screen_x)
	out (c), a    

	;attr 1                                  
	ld a,(npc_screen_y)
	out (c), a                                      

	;attr 2
	ld a,(npc_attribute_2)
	ld b,a
	ld hl,npc_screen_x
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
	ld a,(npc_screen_x)
	add a,16 ;width
	cp b
	ret c

	ld a,(npc_screen_x)
	ld b,a
	ld a,(px)
	add a,16 ;w
	cp b
	ret c

	ld a,(py)
	ld b,a
	ld a,(npc_screen_y)
	add a,20 ;h + offset (standing in front of npc)
	cp b
	ret c

	ld a,(npc_screen_y)
	ld b,a
	ld a,(py)
	add a,16
	cp b
	ret c

	ld hl,npc_screen_x
	inc hl
	ld b,(hl)
	ld hl,px
	inc hl
	ld a,(hl)
	cp b
	ret nz

	ld hl,npc_screen_y
	inc hl
	ld b,(hl)
	ld hl,py
	inc hl
	ld a,(hl)
	cp b
	ret nz


	;collision....
	call collided_solid
	

	ret
;




npc_check_inview:

	;missed viewport by left side
	ld hl,(camera_x) 
	ld b,h 
	ld a,(npc_world_x)
	cp b
	jp c, npc_set_notshowing

	;missed on right side
	ld a,(npc_world_x)
	ld b,a
	ld hl,(camera_x)
	ld a,h
	add a,VIEWPORT_WIDTH-2
	cp b
	jp c, npc_set_notshowing

	;missed on top side
	ld hl,(camera_y)
	ld b,h
	ld a,(npc_world_y)
	cp b
	jp c, npc_set_notshowing

	;missed on bottom side
	ld a,(npc_world_y)
	ld b,a
	ld hl,(camera_y)
	ld a,h
	add a,VIEWPORT_HEIGHT-2
	cp b
	jp c, npc_set_notshowing

	
	ld a,TRUE
	ld (npc_is_showing),a
	;set correct screenspace position...
	call calculate_screenspace_position
	ld a,(npc_attribute_3)
	set 7,a
	ld (npc_attribute_3),a
	
	ret

npc_set_notshowing:
	ld a,FALSE
	ld (npc_is_showing),a

	;reset visibility bit
	ld a,(npc_attribute_3)
	res 7,a
	ld (npc_attribute_3),a

	ret

calculate_screenspace_position:
	ld hl,(camera_x)
	ld b,h
	ld a,(npc_world_x)
	sub b
	add a,a
	add a,a
	add a,a
	ld h,0
	ld l,a
	ld (npc_screen_x),hl

	; BREAKPOINT
	ld hl,(camera_y)
	ld b,h
	ld a,(npc_world_y)
	sub b
	add a,a
	add a,a
	add a,a
	ld h,0
	ld l,a
	ld (npc_screen_y),hl

	ret