    org 0x8000

    DEVICE ZXSPECTRUMNEXT
	
start:
	di
	nextreg $7,3 ; set Mhz mode
	call game_start	
	jp main_loop

main_loop:
	call game_update
	call game_draw
	jp main_loop

STACK_SIZE equ 20
stack_bottom ds STACK_SIZE, 0
stack_top db 0  

	
	include 'retrotools\tools.asm'
	include 'constants.asm'
	include 'game.asm'
	include 'player.asm'
	include 'npc.asm'
	include 'dialog.asm'
	include 'retrotools\keycacher.asm'
	include 'retrotools\spritetools.asm'
	; include 'collectables.asm'
	include 'ui.asm'

	include 'tiledworld.asm'
	include 'sprites.asm'
	

	MMU 6,17
	org 0xC000
	incbin "fonts/font1.spr"






	SAVENEX OPEN "main.nex", start , stack_top
    SAVENEX CORE 3, 0, 0      
    SAVENEX CFG 0, 0            
	SAVENEX AUTO
    SAVENEX CLOSE 



