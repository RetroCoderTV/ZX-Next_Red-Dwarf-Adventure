MAP_ADDRESS equ 0xC000
CAM_SCROLL_SPEED equ 32
VIEWPORT_WIDTH equ 40
VIEWPORT_HEIGHT equ 32
WORLD_WIDTH equ 80 ;fix it , the code breaks when this is not 80
WORLD_HEIGHT equ 64

TILESET_SIZE equ 1984 

camera_x dw 0x0000
camera_y dw 0x0000


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
	ld a,7
	nextreg $14,a ;set global transparency colour
	xor a 
	
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
	ld bc,VIEWPORT_WIDTH
drawview_start:
	push bc
	ldir
	pop bc
	add hl,bc
	ld a,d
	cp 0x60
	ret z
	jp drawview_start

;stasis booth=2a,2b,2c,2d,2e,2f,30,31,32 [stasis door=33,34,35,36,37,38]

;$33=top of solid tiles
;$39=top of triggers
;$46=top of floor
thedwarf:
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$01,$02,$3d,$01,$02,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$03,$04,$3d,$03,$04,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$05,$06,$3d,$05,$06,$3c,$2a,$2b,$2c,$2a,$2b,$2c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$2d,$2e,$2f,$2d,$2e,$2f,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$30,$31,$32,$30,$31,$32,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$33,$34,$35,$33,$34,$35,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$36,$37,$38,$36,$37,$38,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c

	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$2a,$2b,$2c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$2d,$2e,$2f,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$30,$31,$32,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$33,$34,$35,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$36,$37,$38,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
	db $3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c,$3d,$3c
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




