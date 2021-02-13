drawString:
	ld	a,(hl)
	inc	hl
	or	a,a
	ret	z
	call	drawChar
	jr	drawString

drawGhostScore:
	ld	hl,s200loc
	ld	de,s200ghost_sprite
	ld	a,(s200tmr)
	or	a,a
	call	nz,+_
	ld	hl,s400loc
	ld	de,s400ghost_sprite
	ld	a,(s400tmr)
	or	a,a
	call	nz,+_
	ld	hl,s800loc
	ld	de,s800ghost_sprite
	ld	a,(s800tmr)
	or	a,a
	call	nz,+_
	ld	hl,s1600loc
	ld	de,s1600ghost_sprite
	ld	a,(s1600tmr)
	or	a,a
	ret	z
_:	ld	bc,(hl)
	ex	de,hl
	jp	drawSprite
 
drawChar:
	push	bc
	push	hl
	or	a,a
	sbc	hl,hl
	ld	l,b
	add	hl,hl
	ld	de,(SwapBufferLoc_SMC)
	ld	b,lcdWidth/2
	mlt	bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,bc
	add	hl,de
	push	hl
	cp	a,' '
	jr	z,space
	sub	a,48
	or	a,a
	sbc	hl,hl
  
	ld	l,a
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ex	de,hl
	ld	hl,charData
	add	hl,de
	jr	ne
space:
	ld	hl,Char_061
ne:
	pop	de  ; de -> correct place to draw
 
	ld	b,8
_iloop:   
	push	bc
	ld	c,(hl)
	ld	b,8
	ex	de,hl
	push	de
ForeColor =$+1
BackColor =$+2
	ld	de,$0102
_i2loop:
	ld	(hl),d
	rlc	c
	jr	nc,+_
	ld	(hl),e
_:
	inc	hl
	djnz	_i2loop
NextL:
	ld	bc,320-8
	add	hl,bc
	pop	de
	ex	de,hl
	inc	hl
	pop	bc
	djnz	_iloop
	pop	hl
	pop	bc
	ld	a,b
	add	a,4
	ld	b,a
	ret

getNewString: 
	or	a,a
	sbc	hl,hl
	ld	(CursLoc),hl
	ld	(CurrTable),hl
	ld	hl,ScoreStrings
	push	hl
	pop	de
	inc	de
	ld	(hl),' '
	ld	bc,10
	ldir
	ld	(hl),0
	jp	swapCharTables
 
cursLeft:
	ld	a,(CursLoc)
	or	a,a
	jr	z,+_
	dec	a
	jr	++_
_:
	ld	a,9
_:
	ld	(CursLoc),a
	jr	drawHIString
cursRight:
	ld	a,(CursLoc)
	inc	a
	cp	a,10
	jr	nz,+_
	xor	a
_:
	ld	(CursLoc),a
	jr	drawHIString
GetString:
	call	getLoop
	cp	a,sk2nd
	ret	z
	cp	a,skEnter
	ret	z
	cp	a,skLeft
	jr	z,cursLeft
	cp	a,skRight
	jr	z,cursRight
	cp	a,skDel
	jp	z,DeleteChar
	cp	a,skAlpha
	jp	z,swapCharTables
	sub	a,10
	jr	c,GetString
	ld	hl,(CurrTable)
	call	_AddHLandA
	ld	a,(hl)
	or	a,a
	jr	z,GetString
	ld	de,(CursLoc)
	ld	hl,ScoreStrings
	add	hl,de
	ld	(hl),a
	ld	a,e
	inc	a
	cp	a,10
	jr	nz,drawHIString
	xor	a
drawHIString:
	ld	hl,ScoreStrings
	ld	de,ScoreStrings2
	push	de
	ld	bc,11
	ldir
	ld	(CursLoc),a
	pop	hl
	call	_AddHLandA
	ld	a,(CursChar)
	ld	(hl),a
	printf(ScoreStrings2, 140,150)
	call	fullBufcpy
	jr	GetString
DeleteChar:
	ld	a,(CursLoc)
	ld	hl,ScoreStrings
	call	_AddHLandA
	ld	(hl),' '
	jp	GetString
swapCharTables:
	ld	hl,(CurrTable)
	ld	de,InputTableCAPS
	call	cphlde
	jr	z,MakeNumbers
	ex	de,hl
	ld	a,';'		; A
	jr	+_
MakeNumbers:
	ld	hl,InputTableNONE
	ld	a,'<'		; 1
_:
	ld	(CurrTable),hl
	ld	(CursChar),a
	ld	a,(CursLoc)
	jr	drawHIString

getLoop:
	call	_GetCSC
	or	a,a
	jr	z,getLoop
	ret

InputTableNONE:
	.db $2B,$2D,$2A,$2F,"'",$00,$00,$3F,$33,$36,$39,$29,$00,$00,$00,$2E,$32,$35,$38,$28,$00,$00,$00,$30,$31,$34,$37,$2C
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
InputTableCAPS:
	.db $00,$57,$52,$4D,$48,$00,$00,$3F,$21,$56
	.db $51
	.db $4C
	.db $47
	.db $00
	.db $00
	.db $3A
	.db $5A
	.db $55
	.db $50
	.db $4B
	.db $46
	.db $43
	.db $00
	.db $20
	.db $59
	.db $54
	.db $4F
	.db $4A
	.db $45
	.db $42
	.db $00
	.db $00
	.db $58
	.db $53
	.db $4E
	.db $49
	.db $44
	.db $41
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
	.db $00
