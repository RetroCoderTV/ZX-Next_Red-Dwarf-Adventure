MAP_ADDRESS equ 0xC000
CAM_SCROLL_SPEED equ 32
VIEWPORT_WIDTH equ 40
VIEWPORT_HEIGHT equ 32
WORLD_WIDTH equ 50 ;fix it , the code breaks when this is not 80
WORLD_HEIGHT equ 64

TILESET_SIZE equ 2272 

camera_x dw 0x0000
camera_y dw 0x0000


SCREEN_LEVEL equ 0
SCREEN_FIGHT equ 1
SCREEN_INVENTORY equ 2

screen_manager_current_state db SCREEN_LEVEL


init_tiles:
	;load palette
	call set_palette

	;load tile defs
	nextreg $56, 16
	ld hl,MAP_ADDRESS
	ld de,$6000
	ld bc,TILESET_SIZE
	ldir

	nextreg $6b,%10100000
	nextreg $6c,0
	nextreg $6e,$40
	nextreg $6f,$60
	nextreg $68,%10000000
	nextreg $43,%00110000

	ld a,4 ;magenta
	nextreg $4c,a ;set tilemap transparency colour
	
	xor a 
	nextreg $14,a ;set global transparency colour
	nextreg $30,a ;tile x offset =0
	nextreg $31,a ;tile y offset

	call tiledworld_draw_view

    ret

set_palette:
	ld hl,tilepalette
	nextreg $43,%00110000
	ld bc,0
uploadpal:
	ld a,b
	nextreg $40,a
	inc b
	ld a,(hl)
	nextreg $41,a
	inc hl
	ld a,(hl)
	nextreg $41,a
	inc hl
	ld a,b
	or a
	jp nz,uploadpal
	ret


tiledworld_scroll_up:
	ld hl,(camera_y)
	ld a,h
	cp 2
	jp c,do_move_up

	ld de,-CAM_SCROLL_SPEED
	add hl,de
	ld (camera_y),hl

	ld hl,(prev_y)
	ld de,1
	add hl,de
	ld (prev_y),hl

	call tiledworld_draw_view
	ret

tiledworld_scroll_down:
	ld hl,(camera_y)
	ld a,h
	cp WORLD_HEIGHT-VIEWPORT_HEIGHT
	jp z, do_move_down

	ld de,CAM_SCROLL_SPEED
	add hl,de
	ld (camera_y),hl

	ld hl,(prev_y)
	ld de,-1
	add hl,de
	ld (prev_y),hl

	call tiledworld_draw_view
	ret



tiledworld_scroll_left:
	ld hl,(camera_x)
	ld a,h
	or l
	jp z,do_move_left

	ld de,-CAM_SCROLL_SPEED
	add hl,de
	ld (camera_x),hl

	ld hl,(prev_x)
	ld de,1
	add hl,de
	ld (prev_x),hl

	call tiledworld_draw_view
	ret


tiledworld_scroll_right:
	ld hl,(camera_x)
	ld a,h
	cp WORLD_WIDTH-VIEWPORT_WIDTH
	jp z,try_move_right

	ld hl,(camera_x)
	ld de,CAM_SCROLL_SPEED
	add hl,de
	ld (camera_x),hl

	ld hl,(prev_x)
	ld de,-1
	add hl,de
	ld (prev_x),hl



	call tiledworld_draw_view
	ret


tiledworld_draw_view:
	ld hl,thedwarf
	ld bc,(camera_y)
	ld d,b
	ld a,WORLD_WIDTH
	ld e,a
	mul d,e
	add hl,de
	ld de,(camera_x)
	ld e,d
	ld d,0
	add hl,de
	ld de,0x4000
	ld bc,WORLD_WIDTH-VIEWPORT_WIDTH
drawview_start:
	push bc
	ld bc,VIEWPORT_WIDTH
	ldir
	pop bc
	add hl,bc
	ld a,d
	cp 0x60
	ret z
	jp drawview_start




tiledworld_draw_view_fight:
	ld hl,0x4000+(VIEWPORT_WIDTH*8)
	ld a,VIEWPORT_WIDTH
drw_fight_line1:
	ld (hl),$40
	inc hl
	dec a
	cp 0
	jp nz,drw_fight_line1

	ld hl,0x4000+(VIEWPORT_WIDTH*23)
	ld a,VIEWPORT_WIDTH
drw_fight_line2:
	ld (hl),$40
	inc hl
	dec a
	cp 0
	jp nz,drw_fight_line2

	ret

clear_view:
	ld hl,$4000
clr_view:
	ld (hl),$47
	inc hl
	ld a,h
	cp $60
	jp c, clr_view
	ret
	


start_fight:

	ld a,(screen_manager_current_state)
	cp SCREEN_FIGHT
	ret z

	ld a,SCREEN_FIGHT
	ld (screen_manager_current_state),a

	call clear_view
	call tiledworld_draw_view_fight

	; nextreg $6b,%00100000 ;disable tilemap
	
	call player_start_fight
	call npc_start_fight


	ret





display_fight_scene:
	


	ret







;stasis booth=2a,2b,2c,2d,2e,2f,30,31,32 [stasis door=33,34,35,36,37,38]

;$33=top of solid tiles
;$39=top of triggers
;$46=top of floor
thedwarf:
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46

	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46
	db $43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44,$43,$44
	db $45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46,$45,$46	
;





;computer
;1,2
;3,4
;5,6

;stasis booth=
;2a,2b,2c
;2d,2e,2f
;30,31,32 
;[stasis door]=
;33,34,35
;36,37,38

;$33=top of solid tiles
;$39=top of triggers
;$46=top of floor

tilepalette:
	incbin "tiles/rd_tileset.nxp",0




	MMU 6,16
	org MAP_ADDRESS

	incbin "tiles/rd_tileset.til",0,TILESET_SIZE




