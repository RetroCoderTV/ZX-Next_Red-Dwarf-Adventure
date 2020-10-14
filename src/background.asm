BG_COLOURS equ %00110001

bg_y db 0



;0x5B00
; background_start:
    

;     nextreg $69,%10000000
; 	; nextreg $12,$20 

    
;     ret

; background_start2:
;     nextreg $12,$23
;     ret
    

; background_update:
;     ; call bg_scroll_y
;     ret

; bg_scroll_y:
;     ; ld a,(bg_y)
;     ; nextreg 0x17,a

;     ; inc a
;     ; ld (bg_y),a
;     ret