
FONT_START equ 14

UI_FIGHT_BUTTONS_X equ 19   
UI_FIGHT_BUTTONS_Y equ 0
UI_FIGHT_ENEMY_X equ 0  ;origin for the players text info
UI_FIGHT_ENEMY_Y equ 21  ;origin for the players text info
UI_FIGHT_PLAYER_X equ 17  ;origin for the players text info
UI_FIGHT_PLAYER_Y equ 21  ;origin for the players text info
UI_LABELS_SPACING equ 4
UI_LABELS_COLUMN_WIDTH equ 8
UI_LABELS_ROW_HEIGHT equ 2
UI_BUTTON_HEIGHT equ 1
UI_BUTTON_WIDTH equ 8


ui_label_button_attack db 'ATTACK',0
ui_label_button_run db 'RUN',0
ui_label_button_item db 'ITEM',0
ui_label_button_magic db 'MAGIC',0
ui_label_button_drink db 'DRINK',0
ui_label_hp db 'HP:',0
ui_label_mp db 'MP:',0
ui_label_xp db 'XP:',0
ui_label_lvl db 'LV:',0
ui_selector db '*',0
ui_space db " ",0




ui_selector_x db UI_FIGHT_BUTTONS_X-1
ui_selector_y db UI_FIGHT_BUTTONS_Y




FONT_ASCII_OFFSET equ 33


ui_fight_init_done db FALSE

ui_enemy_hp db 0
ui_enemy_mp db 0
ui_enemy_xp db 0
ui_enemy_lvl db 0


ui_update: 
    ld a,(screen_manager_current_state)
    cp SCREEN_FIGHT
    push af
    call z,ui_fight_init
    pop af
    ret


ui_fight_init:
    

    call ui_fight_update

    ld a,(ui_fight_init_done)
    cp TRUE
    ret z

    ld a,TRUE
    ld (ui_fight_init_done),a

      ;set slot, page

    ;Top half
    call ui_draw_selector

    ld l,UI_FIGHT_BUTTONS_X
    ld h,UI_FIGHT_BUTTONS_Y
    ld de,ui_label_button_attack
    call display_string
    
    ld l,UI_FIGHT_BUTTONS_X
    ld h,UI_FIGHT_BUTTONS_Y+UI_BUTTON_HEIGHT
    ld de,ui_label_button_run
    call display_string

    ld l,UI_FIGHT_BUTTONS_X
    ld h,UI_FIGHT_BUTTONS_Y+(UI_BUTTON_HEIGHT*2)
    ld de,ui_label_button_item
    call display_string

    ld l,UI_FIGHT_BUTTONS_X+(UI_BUTTON_WIDTH)
    ld h,UI_FIGHT_BUTTONS_Y+(UI_BUTTON_HEIGHT)
    ld de,ui_label_button_magic
    call display_string

    ld l,UI_FIGHT_BUTTONS_X+(UI_BUTTON_WIDTH)
    ld h,UI_FIGHT_BUTTONS_Y+(UI_BUTTON_HEIGHT*2)
    ld de,ui_label_button_drink
    call display_string

    ;Bottom Half of screen:

    ;Display enemy texts
    call ui_get_enemy_texts
     ;HP
    ld l,UI_FIGHT_ENEMY_X
    ld h,UI_FIGHT_ENEMY_Y
    ld de,ui_label_hp
    call display_string
    ld l,UI_FIGHT_ENEMY_X+UI_LABELS_SPACING
    ld h,UI_FIGHT_ENEMY_Y
    ld a,255 ;todo: find a way to copy the single enemy we are fighting to get his details
    call display_numbers

    ;MP
    ld l,UI_FIGHT_ENEMY_X+UI_LABELS_COLUMN_WIDTH
    ld h,UI_FIGHT_ENEMY_Y
    ld de,ui_label_mp
    call display_string
    ld l,UI_FIGHT_ENEMY_X+UI_LABELS_COLUMN_WIDTH+UI_LABELS_SPACING
    ld h,UI_FIGHT_ENEMY_Y
    ld a,(ui_enemy_mp)
    call display_numbers

    ;XP
    ld l,UI_FIGHT_ENEMY_X
    ld h,UI_FIGHT_ENEMY_Y+UI_LABELS_ROW_HEIGHT
    ld de,ui_label_xp
    call display_string
    ld l,UI_FIGHT_ENEMY_X+UI_LABELS_SPACING
    ld h,UI_FIGHT_ENEMY_Y+UI_LABELS_ROW_HEIGHT
    ld a,(ui_enemy_xp)
    call display_numbers

    ;LVL
    ld l,UI_FIGHT_ENEMY_X+UI_LABELS_COLUMN_WIDTH
    ld h,UI_FIGHT_ENEMY_Y+UI_LABELS_ROW_HEIGHT
    ld de,ui_label_lvl
    call display_string
    ld l,UI_FIGHT_ENEMY_X+UI_LABELS_COLUMN_WIDTH+UI_LABELS_SPACING
    ld h,UI_FIGHT_ENEMY_Y+UI_LABELS_ROW_HEIGHT
    ld a,(ui_enemy_lvl)
    call display_numbers

    ;display players texts
    ;HP
    ld l,UI_FIGHT_PLAYER_X
    ld h,UI_FIGHT_PLAYER_Y
    ld de,ui_label_hp
    call display_string
    ld l,UI_FIGHT_PLAYER_X+UI_LABELS_SPACING
    ld h,UI_FIGHT_PLAYER_Y
    ld a,(player_hp)
    call display_numbers

    ;MP
    ld l,UI_FIGHT_PLAYER_X+UI_LABELS_COLUMN_WIDTH
    ld h,UI_FIGHT_PLAYER_Y
    ld de,ui_label_mp
    call display_string
    ld l,UI_FIGHT_PLAYER_X+UI_LABELS_COLUMN_WIDTH+UI_LABELS_SPACING
    ld h,UI_FIGHT_PLAYER_Y
    ld a,(player_mp)
    call display_numbers

    ;XP
    ld l,UI_FIGHT_PLAYER_X
    ld h,UI_FIGHT_PLAYER_Y+UI_LABELS_ROW_HEIGHT
    ld de,ui_label_xp
    call display_string
    ld l,UI_FIGHT_PLAYER_X+UI_LABELS_SPACING
    ld h,UI_FIGHT_PLAYER_Y+UI_LABELS_ROW_HEIGHT
    ld a,(player_xp)
    call display_numbers

    ;LVL
    ld l,UI_FIGHT_PLAYER_X+UI_LABELS_COLUMN_WIDTH
    ld h,UI_FIGHT_PLAYER_Y+UI_LABELS_ROW_HEIGHT
    ld de,ui_label_lvl
    call display_string
    ld l,UI_FIGHT_PLAYER_X+UI_LABELS_COLUMN_WIDTH+UI_LABELS_SPACING
    ld h,UI_FIGHT_PLAYER_Y+UI_LABELS_ROW_HEIGHT
    ld a,(player_lvl)
    call display_numbers
   
    ret


;HL=yx
ui_draw_selector:
   
    ld hl,(ui_selector_x)
    ld de,ui_selector
    call display_string
    
    ret

ui_delete_selector:
    ld hl,(ui_selector_x)
    ld de,ui_space
    call display_string
    BREAKPOINT
    ret


ui_get_enemy_texts:
    ld ix,npcs
uiget_start:
    ld a,(ix+0)
    cp 255
    ret z

    ld a,(current_fight_enemy)
    cp (ix+6)
    jp nz, uiget_next

    ;this is the correct enemy:
    ld a,(ix+12)
    ld (ui_enemy_hp),a
    ld a,(ix+13)
    ld (ui_enemy_mp),a
    ld a,(ix+14)
    ld (ui_enemy_xp),a
    ld a,(ix+15)
    ld (ui_enemy_lvl),a
    ret
uiget_next:
    ld de,NPCS_DATA_LENGTH
    add ix,de
    jp uiget_start





ui_fight_update:
    ld a,(keypressed_W)
    cp TRUE
    call z, ui_move_selector_up

    ld a,(keypressed_S)
    cp TRUE
    call z,ui_move_selector_down
    ret



ui_move_selector_up:
    ld a,(ui_selector_y)
    cp UI_FIGHT_BUTTONS_Y
    ret z
    dec a
    call ui_delete_selector
    ld (ui_selector_y),a

    call ui_draw_selector
    ret
ui_move_selector_down:
    ld a,(ui_selector_y)
    cp UI_FIGHT_BUTTONS_Y+3 ;3 buttons max column height
    ret z
    inc a
    call ui_delete_selector
    ld (ui_selector_y),a

    call ui_draw_selector
    ret