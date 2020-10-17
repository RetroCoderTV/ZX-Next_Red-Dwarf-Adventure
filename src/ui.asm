UI_HP_X equ 10
UI_HP_Y equ 200
ui_fight_label db 'HP ',0

FONT_ASCII_OFFSET equ 34

ui_fight_init:
    nextreg $56,17

    ld l,UI_HP_X
    ld h,UI_HP_Y
    ld de,ui_fight_label
    call display_text

 
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
   