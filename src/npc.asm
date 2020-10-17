NPC_ANIMATION_FRAME_TIME equ 12
; npc_is_showing db FALSE
NPC_FIGHT_X equ 60
NPC_FIGHT_Y equ 100



;0=world x
;1=world y
;2,3=position x lh
;4,5=position y lh
;6=attribute slot
;7=attr 2
;8=attr 3
;9=attr 4
;10=is showing
;11=animation counter
;11=hp
;12=mp
;13=xp
;14=lvl

npcs:
	db 00,10 : dw 0,0 : db 62, %00000000, %11000001, %00100000, FALSE, 0,30,0,10,5
	db 42,08 : dw 0,0 : db 61, %00000000, %11000001, %00100000, FALSE, 0,250,100,100,14
	db 44,44 : dw 0,0 : db 60, %00000000, %11000001, %00100000, FALSE, 0,180,250,55,75
	db 03,40 : dw 0,0 : db 59, %00000000, %11000001, %00100000, FALSE, 0,45,10,1,1
	db 255
NPCS_DATA_LENGTH equ 16


npcs_init:
	ld ix,npcs
npcs_init_start:
	ld a,(ix+0)
	cp 255
	ret z
	
	call npc_init
npcs_init_next:
	ld de,NPCS_DATA_LENGTH
	add ix,de
	jp npcs_init_start
;

npcs_update:
	ld ix,npcs
npcs_upd_start:
	ld a,(ix+0)
	cp 255
	ret z

	call npc_update
npcs_upd_next:
	ld de,NPCS_DATA_LENGTH
	add ix,de
	jp npcs_upd_start
;

npcs_draw:
	ld ix,npcs
npcs_drw_start:
	ld a,(ix+0)
	cp 255
	ret z


	call npc_draw
npcs_drw_next:
	ld de,NPCS_DATA_LENGTH
	add ix,de
	jp npcs_drw_start	
;



npc_init:
	call npc_check_inview
	ret

;IX=current npc
npc_start_fight:
	;todo: make all npc sprites not visible
	;todo: make this npc visible
	ld a,(ix+6)
	ld (current_fight_enemy),a ;save this enemy slot, to see which one we are fighting
	ld (ix+2),NPC_FIGHT_X
	ld (ix+3),0
	ld (ix+4),NPC_FIGHT_Y
	ret


;IX=current npc
npc_update:
	ld a,(screen_manager_current_state)
	cp SCREEN_LEVEL
	push af
	call z,npc_update_level
	pop af
	push af
	call z,npc_update_fight
	pop af
	ret


npc_update_level:
	call npc_check_inview

	ld a,(ix+11)
	inc a
	ld (ix+11),a
	cp NPC_ANIMATION_FRAME_TIME
	call nc, animate_npc

	call npc_collide_player

    ret


npc_update_fight:
	ld a,(current_fight_enemy)
	cp (ix+6)
	ret z

	ret

npc_draw:
	;select slot
	ld a,(ix+6)
	ld bc, $303b ;selection of pattern
	out (c), a

	ld bc, $57 ;0x57=attribute writing port
	;attr 0
	ld a,(ix+2)
	out (c), a    

	;attr 1                                  
	ld a,(ix+4)
	out (c), a                                      

	;attr 2
	ld a,(ix+7)
	ld b,a
	ld a,(ix+3) ;x HB
	or b
	out (c),a

	;attr 3
	ld a,(ix+8)
	out (c),a

	;attr 4
	ld a,(ix+9)
	out (c),a

	ret




animate_npc:
	call flip_npc_sprite
	xor a
	ld (ix+11),a
	ret


flip_npc_sprite:
	ld a,(ix+7)
	xor %00001000
	ld (ix+7),a
	ret




npc_collide_player:
	ld a,(px)
	ld b,a
	ld a,(ix+2)
	add a,16 ;width
	cp b
	ret c

	ld a,(ix+2)
	ld b,a
	ld a,(px)
	add a,16 ;w
	cp b
	ret c

	ld a,(py)
	ld b,a
	ld a,(ix+4)
	add a,20 ;h + offset (standing in front of npc)
	cp b
	ret c

	ld a,(ix+4)
	ld b,a
	ld a,(py)
	add a,16
	cp b
	ret c

	ld a,(ix+3)
	ld b,a
	ld hl,px
	inc hl
	ld a,(hl)
	cp b
	ret nz

	ld a,(ix+5)
	ld b,a
	ld hl,py
	inc hl
	ld a,(hl)
	cp b
	ret nz


	;collision....
	call start_fight
	

	ret
;




npc_check_inview:
	;missed viewport by left side
	ld hl,(camera_x) 
	ld b,h 
	ld a,(ix+0)
	cp b
	jp c, npc_set_notshowing

	;missed on right side
	ld a,(ix+0)
	ld b,a
	ld hl,(camera_x)
	ld a,h
	add a,VIEWPORT_WIDTH-2
	cp b
	jp c, npc_set_notshowing

	;missed on top side
	ld hl,(camera_y)
	ld b,h
	ld a,(ix+1)
	cp b
	jp c, npc_set_notshowing

	;missed on bottom side
	ld a,(ix+1)
	ld b,a
	ld hl,(camera_y)
	ld a,h
	add a,VIEWPORT_HEIGHT-2
	cp b
	jp c, npc_set_notshowing

	ld a,TRUE
	ld (ix+10),a
	;set correct screenspace position...
	call calculate_screenspace_position
	ld a,(ix+8)
	set 7,a
	ld (ix+8),a
	
	ret

npc_set_notshowing:
	ld a,FALSE
	ld (ix+10),a

	;reset visibility bit
	ld a,(ix+8)
	res 7,a
	ld (ix+8),a

	ret



;INPUTS: IX= object to position
calculate_screenspace_position:
	ld hl,(camera_y)
	ld b,h
	ld a,(ix+1)
	sub b
	add a,a
	add a,a
	add a,a
	ld h,0
	ld l,a
	ld (ix+4),hl

	ld hl,(camera_x)
	ld b,h
	ld a,(ix+0)
	sub b
	ld l,a
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl
	ld (ix+2),hl

	

	ret

