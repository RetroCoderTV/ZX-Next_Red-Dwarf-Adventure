game_start: 
	nextreg $56, 14
	ld b,SPRITE_COUNT
    ld hl,MAP_ADDRESS
    call init_sprites

	nextreg $15,%00000011
	call init_tiles

	; call display_dialog_text
	
    ret

game_update:
	ld b,1
	call WaitRasterLine
  	
    call check_keys
	call player_update


	ret

game_draw:
	call player_draw

    
	ret









