game_start: 

	


	nextreg $56, 14
	ld b,SPRITE_COUNT
    ld hl,MAP_ADDRESS
    call init_sprites

	nextreg $15,%00000011
	call init_tiles
	call npcs_init

	

	
	
    ret

game_update:
	ld b,1
	call WaitRasterLine
  	
    call check_keys
	call npcs_update
	call player_update
	call ui_update

	ret

game_draw:
	call player_draw
	call npcs_draw

    
	ret









