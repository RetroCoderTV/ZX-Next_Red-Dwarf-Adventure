py dw 128
px dw 128 

prev_y dw 128
prev_x dw 128

player_world_x db 0
player_world_y db 0

PLAYER_SPEED equ 1
PLAYER_ATTR_SLOT equ 63
player_attribute_2 db %00000000
player_attribute_3 db %11000000
player_attribute_4 db %00100000




player_type db %10000000 ;type= VISIBILITY BYTE + IMAGE ID
player_hp db 100
player_mp db 0
player_xp db 0
player_lvl db 0


;lager,bazookoid,popadom,fish,locker key,banana,something else,one more
player_inventory db %00001100


animation_counter db 0
ANIMATION_FRAME_TIME equ 12



PLAYER_FIGHT_POS_X equ 230
PLAYER_FIGHT_POS_Y_1 equ 100




player_update:
	ld a,(screen_manager_current_state)
	cp SCREEN_LEVEL
	push af
	call z,player_update_level
	pop af
	push af
	call z,player_update_fight
	pop af
	; push af
	; call z,player_update_inventory
	; pop af
	ret



player_update_level:
	ld a,(animation_counter)
	inc a
	ld (animation_counter),a
	cp ANIMATION_FRAME_TIME
	call nc, animate_player


	ld hl,(px)
	ld (prev_x),hl
	ld hl,(py)
	ld (prev_y),hl

	ld a,(keypressed_A)
	cp TRUE
	call z,move_left

	ld a,(keypressed_D)
	cp TRUE
	call z, move_right

	ld a,(keypressed_W)
	cp TRUE
	call z, move_up

	ld a,(keypressed_S)
	cp TRUE
	call z, move_down

    ret


player_start_fight:
	; BREAKPOINT
	ld hl,px
	ld (hl),PLAYER_FIGHT_POS_X
	ld hl,py
	ld (hl),PLAYER_FIGHT_POS_Y_1
	ret

player_update_fight:
	call display_fight_scene
	ret

player_draw:
	;select slot
	ld a,PLAYER_ATTR_SLOT
	ld bc, $303b ;selection of pattern
	out (c), a

	ld bc, $57 ;0x57=attribute writing port
	;attr 0
	ld a,(px)
	out (c), a    

	;attr 1                                  
	ld hl,py
	ld a,(hl)
	out (c), a                                      

	;attr 2
	ld a,(player_attribute_2)
	ld b,a
	ld hl,px
	inc hl
	ld a,(hl)
	or b
	out (c),a

	;attr 3
	ld a,(player_attribute_3)
	out (c),a

	;attr 4
	ld a,(player_attribute_4)
	out (c),a

	ret



move_up:
	ld hl,(py)
	ld a,l
	cp 66 ;scroll boundary top
	push af
	call c, tiledworld_scroll_up
	pop af
	jp c,mu_end
do_move_up:
	ld hl,(py)
	ld a,l
	cp 2
	ret c

	ld de,-PLAYER_SPEED
	add hl,de
	ld (py),hl
mu_end:
	call calculate_world_position
	call check_collision_solid_up
	ret

	


move_down:
	ld hl,(py)
	ld a,l
	cp 160 ;scroll boundary bottom
	push af
	call nc, tiledworld_scroll_down
	pop af
	jp nc,md_end
do_move_down:
	ld hl,(py)
	ld a,l
	cp 255-18
	ret nc

	ld de,PLAYER_SPEED
	add hl,de
	ld (py),hl
md_end:
	call calculate_world_position
	call check_collision_solid_down
	ret



move_left:
	ld hl,(px)
	ld a,l
	cp 100 ;scroll boundary left
	jp c,ml_check_msb
do_move_left:
	ld hl,(px)
	ld a,h
	or l
	ret z
	ld de,-PLAYER_SPEED
	add hl,de
	ld (px),hl
ml_end:
	call calculate_world_position
	call check_collision_solid_left
	ret
ml_check_msb:
	ld a,h
	cp 0
	push af
	call z,tiledworld_scroll_left
	pop af
	jp z,ml_end
	jp nz,do_move_left


move_right:
	ld a,(px)
	cp 220 ;scroll boundary right
	push af
	call nc,tiledworld_scroll_right
	pop af
	jp nc, mr_end
try_move_right:
	ld hl,(px)
	ld a,l
	cp 64-16 ;LowerByte=64 pw=16
	jp z,move_right_check_msb
do_move_right:
	ld de,PLAYER_SPEED
	add hl,de
	ld (px),hl
mr_end:
	call calculate_world_position
	call check_collision_solid_right
	ret
move_right_check_msb:
	ld a,h
	cp 0
	jp z,do_move_right
	ret




;todo: This only works on left side of screen. If X is over 255, this breaks!
calculate_world_position:
	ld hl,(px)
	ld a,l
	and %11111000 ;we need to lose the first 3 bits so we don't get them back after rotate
	rrca
	rrca
	rrca
	ld b,a
	ld hl,(px)
	ld a,h
	cp 0
	call nz, addmsb
	
	ld hl,(camera_x)
	ld a,h
	add a,b
	ld (player_world_x),a


	ld hl,(py)
	ld a,l
	and %11111000
	rrca
	rrca
	rrca
	ld b,a
	ld hl,(camera_y)	
	ld a,h
	add a,b
	ld (player_world_y),a

	ret

addmsb:
	ld a,32 ;8th of the value of full byte
	add a,b
	ld b,a
	ret

check_collision_solid_up:
	ld hl,thedwarf
	ld a,(player_world_y)
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ld hl,thedwarf
	ld a,(player_world_y)
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	add a,2
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ret

check_collision_solid_down:
	ld hl,thedwarf
	ld a,(player_world_y)
	add a,2
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ld hl,thedwarf
	ld a,(player_world_y)
	add a,2
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	add a,2
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ret


check_collision_solid_left:
	ld hl,thedwarf
	ld a,(player_world_y)
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ld hl,thedwarf
	ld a,(player_world_y)
	add a,2
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ret

check_collision_solid_right:
	ld hl,thedwarf
	ld a,(player_world_y)
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	add a,2
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ld hl,thedwarf
	ld a,(player_world_y)
	add a,2
	ld d,a
	ld e,WORLD_WIDTH
	mul d,e
	add hl,de
	ld a,(player_world_x)
	add a,2
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp $3a
	jp c,collided

	ret

;$33=top of solid tiles
;$39=top of triggers
;$46=top of floor
collided:
	ld a,(hl)
	cp $33
	jp nc,collided_trigger

	call collided_solid
	ret


collided_solid:
	ld hl,(prev_x)
	ld (px),hl
	ld hl,(prev_y)
	ld (py),hl
	ret

collided_trigger:
	call mirror_character_sprite_y
	ret




animate_player:
	call mirror_character_sprite_x
	xor a
	ld (animation_counter),a
	ret


mirror_character_sprite_x:
	ld a,(player_attribute_2)
	xor %00001000
	ld (player_attribute_2),a
	ret


mirror_character_sprite_y
	ld a,(player_attribute_2)
	xor %00000100
	ld (player_attribute_2),a
	ret
	ret




	