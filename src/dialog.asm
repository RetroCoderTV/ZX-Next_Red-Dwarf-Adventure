
	

; DIALOG_HEIGHT equ 4
; LETTER_A equ 31
; FONT_ASCII_OFFSET equ 34



; DIALOG_START_X equ 0
; dialog_x db 0
; dialog_y db 23-DIALOG_HEIGHT


; test_message db "LIKE AND SUBSCRIBE RETROCODER TV",0


; display_dialog_text:
;     ld a,DIALOG_START_X
;     ld (dialog_x),a
;     ld de,test_message

; disp_char:
;     ld hl,(dialog_x)
;     ld a,(de)
;     cp 0
;     ret z
;     cp ' '
;     jp z,disp_char_end
;     sub FONT_ASCII_OFFSET
;     push de
;     push hl
;     call PlotTile8
;     pop hl
;     pop de
; disp_char_end:
;     inc de
;     ld a,(dialog_x)
;     add a,1
;     ld (dialog_x),a
;     jp disp_char
   