FONT_ZERO equ 14


UI_HP_X equ 18
UI_HP_Y equ 21
ui_fight_label db 'HP: ',0

FONT_ASCII_OFFSET equ 34


ui_fight_init_done db FALSE

ui_update: 
    ld a,(screen_manager_current_state)
    cp SCREEN_LEVEL
    ret z
    cp SCREEN_FIGHT
    push af
    call z,ui_fight_init
    pop af
    ret






ui_fight_init:
    ld a,(ui_fight_init_done)
    cp TRUE
    ret z

    ld a,TRUE
    ld (ui_fight_init_done),a

    nextreg $56,17 ;set slot, page

    ld l,UI_HP_X
    ld h,UI_HP_Y
    ld de,ui_fight_label
    call display_text

    ld l,UI_HP_Y+1
    ld h,UI_HP_Y
    ld a,122
    call display_numbers
 
    ret



;HL=start x
;DE=message address
display_text:
    ld a,(de)
    cp 0
    ret z
    cp ' '
    jp z,disp_char_end
    sub FONT_ASCII_OFFSET
    push de
    push hl
    call PlotTile8
    pop hl
    pop de
disp_char_end:
    inc de
    inc l
    jp display_text
   



display_numbers:
    ld c,-100
    call dn_add_offset
    ld c,-10
    call dn_add_offset
    ld c,-1
dn_add_offset:
    ld b,FONT_ZERO-1
dn_inc:
    inc b
    add a,c
    jr c, dn_inc
    sub c ;actually adding (its holding minus number)
    push af
    ld a,b
    push hl
    call PlotTile8
    pop hl
    inc l
    pop af

    ret


