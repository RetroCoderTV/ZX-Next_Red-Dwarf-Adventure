; Sprite Attribute 0
;     X X X X X X X X
	
; Sprite Attribute 1
;     Y Y Y Y Y Y Y Y

; Sprite Attribute 2
;     P P P P XM YM R X8/PR

; Sprite Attribute 3
;     V E N5 N4 N3 N2 N1 N0 (NNNNN=Pattern ID)

; Sprite Attribute 4
; A. Extended Anchor Sprite
;     H N6 T X X Y Y Y8
; B. Relative Sprite, Composite Type
;     0 1 N6 X X Y Y PO
; C. Relative Sprite, Unified Type
;     0 1 N6 0 0 0 0 PO


	MMU 6,14
	org MAP_ADDRESS
SPRITE_COUNT equ 6
;lister (crap)
	db  $E3, $E3, $E3, $6D, $E3, $00, $00, $00, $00, $00, $E3, $6D, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $6D, $00, $00, $00, $00, $00, $00, $00, $6D, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $AD, $69, $AD, $AD, $AD, $69, $AD, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $AD, $DB, $AD, $AD, $AD, $DB, $AD, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $AD, $AD, $AD, $AD, $AD, $AD, $AD, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $25, $44, $AD, $69, $69, $69, $AD, $44, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $00, $00, $B5, $FC, $FC, $B5, $00, $00, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $25, $00, $00, $4A, $DA, $93, $B5, $00, $00, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $AD, $AD, $00, $B5, $FC, $DA, $B5, $00, $49, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $92, $93, $B6, $92, $00, $49, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $B5, $DA, $DA, $B5, $00, $49, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $B5, $FC, $FC, $B5, $00, $AD, $AD, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $49, $25, $25, $25, $25, $49, $AD, $AD, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $49, $00, $E3, $E3, $49, $6D, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $6D, $49, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $6D, $49, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
; rpgsprites1:
	db  $E3, $E3, $E3, $E3, $E3, $E3, $00, $00, $00, $00, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $00, $00, $00, $00, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $00, $00, $00, $00, $00, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $00, $FA, $FA, $00, $00, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $00, $00, $00, $00, $FA, $FA, $00, $00, $00, $00, $E3, $E3, $E3;
	db  $E3, $E3, $00, $EE, $00, $FA, $00, $FA, $FA, $00, $FA, $00, $00, $E3, $E3, $E3;
	db  $E3, $00, $EE, $EE, $00, $00, $FA, $FA, $FA, $FA, $00, $00, $00, $00, $E3, $E3;
	db  $E3, $00, $00, $00, $00, $EE, $00, $00, $00, $00, $EE, $EE, $EE, $00, $E3, $E3;
	db  $E3, $00, $00, $FA, $00, $EE, $EE, $00, $00, $EE, $00, $EE, $00, $FA, $00, $E3;
	db  $E3, $E3, $00, $00, $00, $00, $EE, $EE, $EE, $EE, $00, $00, $00, $FA, $00, $E3;
	db  $E3, $E3, $E3, $E3, $00, $EE, $00, $00, $00, $00, $00, $FA, $FA, $00, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $EE, $EE, $00, $EE, $00, $FA, $FA, $00, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $00, $00, $00, $00, $00, $00, $00, $00, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $00, $00, $00, $00, $00, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $EE, $EE, $00, $00, $00, $00, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $00, $00, $00, $00, $00, $00, $00, $00, $E3, $E3, $E3, $E3;

; anchored-test 1/4
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $45;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $45, $E7, $E7;
	db  $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $45, $45, $45, $E7;
	db  $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $45, $45, $45, $E7;
	db  $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $45, $45, $E7, $E7;
	db  $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $E7, $E7, $E7, $E7;

	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $45, $45, $45, $45, $45, $45, $45, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7;
	db  $E7, $E7, $45, $45, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7;
	db  $E7, $E7, $45, $45, $45, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7;
	db  $E7, $E7, $45, $45, $45, $45, $45, $45, $45, $E7, $E7, $E7, $E7, $45, $E7, $E7;
	db  $E7, $E7, $45, $45, $45, $45, $45, $45, $45, $E7, $E7, $E7, $45, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $45, $45, $45, $45, $45, $E7, $E7, $E7, $45, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7;

	db  $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45;
	db  $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $45, $45, $45, $45, $E7, $E7, $45, $45;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $45;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $45;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;

	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $45, $45, $45, $45, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $45, $45, $45, $45, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $45, $45, $45, $45, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $45, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $45, $45, $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $45, $45, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;
	db  $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7, $E7;


