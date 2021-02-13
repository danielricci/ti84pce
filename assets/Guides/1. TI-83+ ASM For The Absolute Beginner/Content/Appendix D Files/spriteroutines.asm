


Use_IY_Safely:

 di
 ret

Return_IY_To_Normal:

 ld iy, flags
 ei
 ret
 
#ifdef Use_RAM_Routine

;--------------------------------
;Clip Big Sprite
;MAX SIZE: 64x64
;ix - Sprite
;b  - height
;c  - width in bytes
;d  - x
;e  - y
LargeClippedMaskedSprite:
	call InitSpriteRoutine
	ld (BigMaskRot1),a
	ld (BigMaskRot4),a
	ld (BigMaskRot2),a
	ld (BigMaskRot5),a
	ld (BigMaskRot3),a
	ld (BigMaskRot6),a
	add a,a
	ld (ClipBigMaskRot1),a
	ld a,$ff
ClipBigMaskRot1 = $+1
	jr $
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl e
	srl e
	srl e
	add hl,de
	ld de,plotsscreen
	add hl,de
				; This is where gbuf offset should be saved.
	ld d,a
	cpl
	ld e,a
				;masks should be saved to
BigMaskSpriteRow:
	push bc
	push hl
	ld b,c
Do_ClipLeftMask = $+1
	jr ClipLeftMask
	push bc
	ld a,(iy)
	inc iy
BigMaskRot1 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and e
	or d
	and (hl)
	ld b,a
	ld a,(ix)
	inc ix
BigMaskRot4 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and e
	or b
	ld (hl),a
	pop bc
ClipLeftMask:
ClipLeftSizeMask = ClipLeftMask-(Do_ClipLeftMask+1)

Do_ClipMiddleMask = $+1
	jr $+2
BigMaskSpriteLoop:
	push bc
	ld a,(iy)
	inc iy
BigMaskRot2 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	ld c,a
	ld a,(ix)
	inc ix
BigMaskRot5 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	ld (MiddleSpriteData),a
	and d
	ld b,a
	ld a,c
	and d
	or e
	and (hl)
	or b
	ld (hl),a
	inc hl
MiddleSpriteData = $+1
	ld a,0
	and e
	ld b,a
	ld a,c
	and e
	or d
	and (hl)
	or b
	ld (hl),a
	pop bc
	djnz BigMaskSpriteLoop
ClipMiddleMask:
ClipMiddleSizeMask = ClipMiddleMask-(Do_ClipMiddleMask+1)

Do_ClipRightMask = $+1
	jr ClipRightMask
	push bc
	ld a,(iy)
BigMaskRot3 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and d
	or e
	and (hl)
	ld b,a
	ld a,(ix)
BigMaskRot6 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and d
	or b
	ld (hl),a
	pop bc
ClipRightMask:
ClipRightSizeMask = ClipRightMask-(Do_ClipRightMask+1)
	pop hl

	ld bc,12			;width of the screen
	add hl,bc

BigMaskSkip = $+1
	ld bc,0
	add ix,bc
	add iy,bc
	pop bc
	dec b
	jp nz,BigMaskSpriteRow
	ret

;--------------------------------
;Clip Big Sprite
;MAX SIZE: 64x64
;ix - Sprite
;b  - height
;c  - width in bytes
;d  - x
;e  - y
LargeClippedSpriteXOR:
	ld a,$AE
	jr LargeClippedSprite
LargeClippedSpriteAND:
	ld a,$A6
	jr LargeClippedSprite
LargeClippedSpriteOverwrite:
	xor a				;nop
	jr LargeClippedSprite
LargeClippedSpriteOR:
	ld a,$B6
LargeClippedSprite
	ld (BigMask1),a
	ld (BigMask2),a
	ld (BigMask3),a
	ld (BigMask4),a
	call InitSpriteRoutine
	ld (BigRot1),a
	ld (BigRot2),a
	ld (BigRot3),a
	add a,a
	ld (ClipBigRot1),a
	ld a,$ff
ClipBigRot1 = $+1
	jr $
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl e
	srl e
	srl e
	add hl,de
	ld de,plotsscreen
	add hl,de
				; This is where gbuf offset should be saved.
	ld d,a
	cpl
	ld e,a
				;masks should be saved to
BigSpriteRow:
	push bc
	push hl
	ld b,c
Do_Clipleft = $+1
	jr Clipleft
	ld a,(ix)
	inc ix
	inc iy
BigRot1 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and e
BigMask1:
	or (hl)
	ld (hl),a
Clipleft:
Clipleftsize = Clipleft-(Do_Clipleft+1)

Do_ClipMiddle = $+1
	jr $+2
BigSpriteloop:
	ld a,(ix)
	inc ix
BigRot2 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	ld c,a
	and d
BigMask2:
	or (hl)
	ld (hl),a
	inc hl
	ld a,c
	and e
BigMask3:
	or (hl)
	ld (hl),a
	djnz BigSpriteloop
ClipMiddle:
ClipMiddlesize = ClipMiddle-(Do_ClipMiddle+1)

Do_ClipRight = $+1
	jr ClipRight
	ld a,(ix)
BigRot3 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and d
BigMask4:
	or (hl)
	ld (hl),a
ClipRight:
ClipRightSize = ClipRight-(Do_ClipRight+1)
	pop hl

	ld bc,12			;width of the screen
	add hl,bc

BigSkip = $+1
	ld bc,0
	add ix,bc
	pop bc
	djnz BigSpriteRow
	ret
	
SpriteOffscreen:
	pop hl
	ret
InitSpriteRoutine:
; Early out, Check if its even remotely on screen
	ld a,e
	cp 64
	jp p,SpriteOffscreen
	add a,b
	jp m,SpriteOffscreen
	jr z,SpriteOffscreen
	ld a,d
	cp 96
	jp p,SpriteOffscreen
	ld a,c
	add a,a
	add a,a
	add a,a
	add a,d
	jp m,SpriteOffscreen
	jr z,SpriteOffscreen

	ld a,e
	or a
	jp p,Check_Clip_bottom
	neg
	push de
	ld hl,0
	ld d,l
	ld e,a
	bit 2,c
	jr z,_
	add hl,de
_	add hl,hl	
	bit 1,c
	jr z,_
	add hl,de
_	add hl,hl	
	bit 0,c
	jr z,_
	add hl,de
_	pop de
	ex de,hl
	add ix,de		;Here you can save the top offset
	add iy,de
	ex de,hl
	ld e,0
	neg
	add a,b
	ld b,a
Check_Clip_Bottom:
	ld a,e
	add a,b
	sub 64
	jp m,Check_Clip_Left
	neg
	add a,b
	ld b,a
Check_Clip_Left:
; at this point you may want to save b
	xor a
	ld (BigMaskSkip),a
	ld (BigSkip),a
	ld a,ClipLeftSize 
	ld (Do_ClipLeft),a
	ld a,ClipLeftSizeMask
	ld (Do_ClipLeftMask),a
	ld a,d
	or a
	jp p,Check_Clip_Right
	cpl
	and $F8
	rra
	rra
	rra
	ex de,hl		;save the clipped left offset
	ld e,a
	ld d,0
	add ix,de
	add iy,de
	ld (BigMaskSkip),a
	ld (BigSkip),a
	ex de,hl
	inc a
	neg
	add a,c
	ld c,a
	xor a
	ld (Do_ClipLeft),a
	ld (Do_ClipLeftMask),a
	ld a,d
	and $07
	ld d,a
Check_clip_right:

	ld a,ClipRightSize
	ld (Do_ClipRight),a
	ld a,ClipRightSizeMask
	ld (Do_ClipRightMask),a
	ld a,c
	add a,a
	add a,a
	add a,a
	add a,d
	sub 96
	jp m,Check_Clip_Middle
	and $F8
	rra
	rra
	rra
	ld l,a
	ld a,(BigSkip)
	add a,l
	inc a
	ld (BigSkip),a
	ld (BigMaskSkip),a
	neg
	add a,c
	ld c,a
	xor a
	ld (Do_ClipRight),a
	ld (Do_ClipRightMask),a
Check_clip_middle:
				; This is where C should be saved.
	xor a
	ld (Do_ClipMiddle),a
	ld (Do_ClipMiddleMask),a
	ld a,c
	or a
	jp nz,DontSkipMiddle
	ld a,ClipMiddlesize
	ld (Do_ClipMiddle),a
	ld a,ClipMiddleSizeMask
	ld (Do_ClipMiddleMask),a
DontSkipMiddle:
	ld l,e
	ld a,d	
	ld h,0
	ld d,h
	add hl,hl
	add hl,de
	add hl,hl
	add hl,hl
	ld e,a
	and $07
	xor 7
	ret



#else




RamCodeStart:

relocate(savesscreen)
;--------------------------------
;Clip Big Sprite
;MAX SIZE: 64x64
;ix - Sprite
;b  - height
;c  - width in bytes
;d  - x
;e  - y
LargeClippedMaskedSprite:
	call InitSpriteRoutine
	ld (BigMaskRot1),a
	ld (BigMaskRot4),a
	ld (BigMaskRot2),a
	ld (BigMaskRot5),a
	ld (BigMaskRot3),a
	ld (BigMaskRot6),a
	add a,a
	ld (ClipBigMaskRot1),a
	ld a,$ff
ClipBigMaskRot1 = $+1
	jr $
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl e
	srl e
	srl e
	add hl,de
	ld de,plotsscreen
	add hl,de
				; This is where gbuf offset should be saved.
	ld d,a
	cpl
	ld e,a
				;masks should be saved to
BigMaskSpriteRow:
	push bc
	push hl
	ld b,c
Do_ClipLeftMask = $+1
	jr ClipLeftMask
	push bc
	ld a,(iy)
	inc iy
BigMaskRot1 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and e
	or d
	and (hl)
	ld b,a
	ld a,(ix)
	inc ix
BigMaskRot4 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and e
	or b
	ld (hl),a
	pop bc
ClipLeftMask:
ClipLeftSizeMask = ClipLeftMask-(Do_ClipLeftMask+1)

Do_ClipMiddleMask = $+1
	jr $+2
BigMaskSpriteLoop:
	push bc
	ld a,(iy)
	inc iy
BigMaskRot2 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	ld c,a
	ld a,(ix)
	inc ix
BigMaskRot5 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	ld (MiddleSpriteData),a
	and d
	ld b,a
	ld a,c
	and d
	or e
	and (hl)
	or b
	ld (hl),a
	inc hl
MiddleSpriteData = $+1
	ld a,0
	and e
	ld b,a
	ld a,c
	and e
	or d
	and (hl)
	or b
	ld (hl),a
	pop bc
	djnz BigMaskSpriteLoop
ClipMiddleMask:
ClipMiddleSizeMask = ClipMiddleMask-(Do_ClipMiddleMask+1)

Do_ClipRightMask = $+1
	jr ClipRightMask
	push bc
	ld a,(iy)
BigMaskRot3 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and d
	or e
	and (hl)
	ld b,a
	ld a,(ix)
BigMaskRot6 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and d
	or b
	ld (hl),a
	pop bc
ClipRightMask:
ClipRightSizeMask = ClipRightMask-(Do_ClipRightMask+1)
	pop hl

	ld bc,12			;width of the screen
	add hl,bc

BigMaskSkip = $+1
	ld bc,0
	add ix,bc
	add iy,bc
	pop bc
	dec b
	jp nz,BigMaskSpriteRow
	ret

;--------------------------------
;Clip Big Sprite
;MAX SIZE: 64x64
;ix - Sprite
;b  - height
;c  - width in bytes
;d  - x
;e  - y
LargeClippedSpriteXOR:
	ld a,$AE
	jr LargeClippedSprite
LargeClippedSpriteAND:
	ld a,$A6
	jr LargeClippedSprite
LargeClippedSpriteOverwrite:
	xor a				;nop
	jr LargeClippedSprite
LargeClippedSpriteOR:
	ld a,$B6
LargeClippedSprite
	ld (BigMask1),a
	ld (BigMask2),a
	ld (BigMask3),a
	ld (BigMask4),a
	call InitSpriteRoutine
	ld (BigRot1),a
	ld (BigRot2),a
	ld (BigRot3),a
	add a,a
	ld (ClipBigRot1),a
	ld a,$ff
ClipBigRot1 = $+1
	jr $
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl a
	srl e
	srl e
	srl e
	add hl,de
	ld de,plotsscreen
	add hl,de
				; This is where gbuf offset should be saved.
	ld d,a
	cpl
	ld e,a
				;masks should be saved to
BigSpriteRow:
	push bc
	push hl
	ld b,c
Do_Clipleft = $+1
	jr Clipleft
	ld a,(ix)
	inc ix
	inc iy
BigRot1 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and e
BigMask1:
	or (hl)
	ld (hl),a
Clipleft:
Clipleftsize = Clipleft-(Do_Clipleft+1)

Do_ClipMiddle = $+1
	jr $+2
BigSpriteloop:
	ld a,(ix)
	inc ix
BigRot2 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	ld c,a
	and d
BigMask2:
	or (hl)
	ld (hl),a
	inc hl
	ld a,c
	and e
BigMask3:
	or (hl)
	ld (hl),a
	djnz BigSpriteloop
ClipMiddle:
ClipMiddlesize = ClipMiddle-(Do_ClipMiddle+1)

Do_ClipRight = $+1
	jr ClipRight
	ld a,(ix)
BigRot3 = $+1
	jr $
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	rrca
	and d
BigMask4:
	or (hl)
	ld (hl),a
ClipRight:
ClipRightSize = ClipRight-(Do_ClipRight+1)
	pop hl

	ld bc,12			;width of the screen
	add hl,bc

BigSkip = $+1
	ld bc,0
	add ix,bc
	pop bc
	djnz BigSpriteRow
	ret
	
SpriteOffscreen:
	pop hl
	ret
InitSpriteRoutine:
; Early out, Check if its even remotely on screen
	ld a,e
	cp 64
	jp p,SpriteOffscreen
	add a,b
	jp m,SpriteOffscreen
	jr z,SpriteOffscreen
	ld a,d
	cp 96
	jp p,SpriteOffscreen
	ld a,c
	add a,a
	add a,a
	add a,a
	add a,d
	jp m,SpriteOffscreen
	jr z,SpriteOffscreen

	ld a,e
	or a
	jp p,Check_Clip_bottom
	neg
	push de
	ld hl,0
	ld d,l
	ld e,a
	bit 2,c
	jr z,_
	add hl,de
_	add hl,hl	
	bit 1,c
	jr z,_
	add hl,de
_	add hl,hl	
	bit 0,c
	jr z,_
	add hl,de
_	pop de
	ex de,hl
	add ix,de		;Here you can save the top offset
	add iy,de
	ex de,hl
	ld e,0
	neg
	add a,b
	ld b,a
Check_Clip_Bottom:
	ld a,e
	add a,b
	sub 64
	jp m,Check_Clip_Left
	neg
	add a,b
	ld b,a
Check_Clip_Left:
; at this point you may want to save b
	xor a
	ld (BigMaskSkip),a
	ld (BigSkip),a
	ld a,ClipLeftSize 
	ld (Do_ClipLeft),a
	ld a,ClipLeftSizeMask
	ld (Do_ClipLeftMask),a
	ld a,d
	or a
	jp p,Check_Clip_Right
	cpl
	and $F8
	rra
	rra
	rra
	ex de,hl		;save the clipped left offset
	ld e,a
	ld d,0
	add ix,de
	add iy,de
	ld (BigMaskSkip),a
	ld (BigSkip),a
	ex de,hl
	inc a
	neg
	add a,c
	ld c,a
	xor a
	ld (Do_ClipLeft),a
	ld (Do_ClipLeftMask),a
	ld a,d
	and $07
	ld d,a
Check_clip_right:

	ld a,ClipRightSize
	ld (Do_ClipRight),a
	ld a,ClipRightSizeMask
	ld (Do_ClipRightMask),a
	ld a,c
	add a,a
	add a,a
	add a,a
	add a,d
	sub 96
	jp m,Check_Clip_Middle
	and $F8
	rra
	rra
	rra
	ld l,a
	ld a,(BigSkip)
	add a,l
	inc a
	ld (BigSkip),a
	ld (BigMaskSkip),a
	neg
	add a,c
	ld c,a
	xor a
	ld (Do_ClipRight),a
	ld (Do_ClipRightMask),a
Check_clip_middle:
				; This is where C should be saved.
	xor a
	ld (Do_ClipMiddle),a
	ld (Do_ClipMiddleMask),a
	ld a,c
	or a
	jp nz,DontSkipMiddle
	ld a,ClipMiddlesize
	ld (Do_ClipMiddle),a
	ld a,ClipMiddleSizeMask
	ld (Do_ClipMiddleMask),a
DontSkipMiddle:
	ld l,e
	ld a,d	
	ld h,0
	ld d,h
	add hl,hl
	add hl,de
	add hl,hl
	add hl,hl
	ld e,a
	and $07
	xor 7
	ret
endrelocate()

EndRamCode


#endif
