;-------------------------------------------------------------------------------
clearScreen:
	ld	hl,vBuf1
	call	clearBuffer
clearVBuf2:
	ld	hl,vBuf2
clearBuffer:
	push	hl
	pop	de
	inc	de
	ld	(hl),BLACK_COLOR
	ld	bc,lcdWidth*lcdHeight
	ldir
	ret

;-------------------------------------------------------------------------------
setup8bppMode:
	ld	a,lcdBpp8
	ld	(mpLcdCtrl),a
	ld	hl,images_paletteStart
	ld	de,mpLcdPalette
	ld	bc,images_paletteEnd-images_paletteStart
	ldir
	ret

;-------------------------------------------------------------------------------
fullBufCpy:
	ld	bc,lcdWidth*lcdHeight
	ld	hl,vBuf2
	ld	de,vBuf1
	ldir
	ret

;-------------------------------------------------------------------------------
drawSprite:
; Inputs:
;  HL -> sprite
;  BC = xy
	push	ix
	push	hl
	ld	de,0
	ld	e,(hl)
	ld	hl,lcdWidth
	or	a,a
	sbc	hl,de
	ld	(SpriteAddAmt_SMC),hl
	pop	hl
	ld	a,e
	ld	(SpriteWidth_SMC),a
	inc	hl
	ld	a,(hl)
	ld	ixh,a
	inc	hl
	push	hl
	or	a,a
	sbc	hl,hl
	ld	l,b
	ld	b,lcdWidth/2
	mlt	bc
DrawSpriteLoop:
	ld	de,(SwapBufferLoc_SMC)
	add	hl,bc
	add	hl,bc
	add	hl,de
	pop	de
SpriteWidth_SMC =$+1
_:	ld	b,0
_:	ld	a,(de)
 	or	a,a
 	jr	z,+_
	ld	(hl),a
_:	inc	hl
	inc	de
	djnz	--_
SpriteAddAmt_SMC =$+1
	ld	bc,0
	add	hl,bc
	dec	ixh
	jr	nz,---_
	pop	ix
	ret

;-------------------------------------------------------------------------------
drawClearingRect:
; Inputs:
;  HL = Width, Height
;  BC = XY
	ld	a,h
	ld	(RectWidth_SMC),a
	ld	a,l
	or	a,a
	sbc	hl,hl
	ld	l,b
	ld	de,(SwapBufferLoc_SMC)
	ld	b,lcdWidth/2
	mlt	bc
	add	hl,bc
	add	hl,bc
	add	hl,de
	push	hl
	pop	de
RectWidth_SMC =$+1
_:	ld	bc,0
	ld	(hl),1
	push	hl
	inc	de
	ldir
	pop	hl
	ld	bc,lcdWidth
	add	hl,bc
	push	hl
	pop	de
	dec	a
	jr	nz,-_
	ret

;-------------------------------------------------------------------------------
getSprite:
; Inputs:
;  DE -> place to store data
;  HL -> sprite (has the size and such)
;  BC = XY
	ld	a,(hl)
	ld	(SpriteWidthSetup_SMC),a
	ldi
	ldi
	inc	bc
	inc	bc
	or	a,a
	sbc	hl,hl
	ld	l,b
	ld	b,lcdWidth/2
	mlt	bc
	add	hl,bc
	add	hl,bc
	ld	bc,(SwapBufferLoc_SMC)
	add	hl,bc
	push	hl
	ld	bc,0
	ld	c,a
	ld	hl,lcdWidth
	or	a,a
	sbc	hl,bc
	ld	(SpriteAddAmtSetup_SMC),hl
	pop	hl
SpriteWidthSetup_SMC =$+1
_:	ld	bc,0
	ldir
SpriteAddAmtSetup_SMC =$+1
	ld	bc,0
	add	hl,bc
	dec	a
	jr	nz,-_
	ret
 
;-------------------------------------------------------------------------------
drawSpriteDouble:
	push	ix
	push	hl
	ld	de,0
	ld	e,(hl)
	ld	hl,lcdWidth
	or	a,a
	sbc	hl,de
	ld	(SpriteAddAmt_SMC),hl
	pop	hl
	ld	a,e
	ld	(SpriteWidth_SMC),a
	inc	hl
	ld	a,(hl)
	ld	ixh,a
	inc	hl
	push	hl
	or	a,a
	sbc	hl,hl
	ld	l,b
	add	hl,hl
SwapBufferLoc_SMC =$+1
	ld	de,vBuf2
	ld	b,lcdWidth/2
	mlt	bc
	add	hl,bc
	add	hl,bc
	jp	DrawSpriteLoop

; dea = xy
; b = length
; white is 2
drawHLine:
	ld	l,a
	ld	h,lcdWidth/2
	mlt	hl
	add	hl,hl
	add	hl,de
	ld	de,(SwapBufferLoc_SMC)
	add	hl,de
	ld	a,2
_:	ld	(hl),a
	inc	hl
	djnz	-_
	ret
; dea = xy
; b = length
drawVLine:
	ld	l,a
	ld	h,lcdWidth/2
	mlt	hl
	add	hl,hl
	add	hl,de
	ld	de,(SwapBufferLoc_SMC)
	add	hl,de
	ld	de,lcdWidth
	ld	a,2
_:	ld	(hl),a
	add	hl,de
	djnz	-_
	ret
