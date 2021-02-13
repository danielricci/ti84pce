getKey:
 di
	ld	hl,DI_Mode	
	ld	(hl),2

	xor	a,a
_:
	cp	a,(hl)
	jr	nz,-_
	ret
 
waitfor2ND:
	call	_getcsc
	cp	a,skDel
	jp	z,FullExit
	cp	a,skClear
	jp	z,FullExit
	cp	a,skEnter
	ret	z
	cp	a,sk2nd
	jr	nz,waitfor2ND
	ret
 
waitforkey:
	call	getKey
	call	chkDelKey
	ld	a,(0F5001Eh)
	or	a,a
	jr	z,waitforkey
	ret
 
chkDelKey:
	ld	a,(kbdG1)
	cp	a,kbdDel
	ret	nz
	jp	FullExit
 
chkPauseKey:
	ld	a,sk2nd
	ld	(kbdLGSC),a		; so it doesn't feel the need to quit
	ld	a,(kbdG1)
	cp	a,kbd2nd
	ret	nz
 
	ld	a,(pressed2nd)
	or	a,a
	ret	nz
 
 loadA(menuSel, 8)
	ld	hl,vbuf1
	ld	(SwapBufferLoc_SMC),hl
 
 eraseRect(72,87,80,49)
	ld	de,71
	ld	a,87
	ld	b,82
	call	drawHLine
	ld	de,71
	ld	a,87+49
	ld	b,82
	call	drawHLine
	ld	de,71
	ld	a,87
	ld	b,49
	call	drawVLine
	ld	de,71+81
	ld	a,87
	ld	b,49
	call	drawVLine
 
	printf(QuitGameString,98,92)
	printf(NoString,98,92+16)
	printf(YesString,98,92+16+16)
 
	call	switchSel
getSel:
	call	_getcsc
	ld	hl,getSel
	push	hl
	cp	a,skUp
	jr	z,switchSel
	cp	a,skDown
	jr	z,switchSel
	cp	a,sk2nd
	jr	z,+_
	cp	a,skEnter
	ret	nz
_:
	popcall()
	xor	a,a
	cpl
	ld	(pressed2nd),a
 
	ld	hl,vbuf2
	ld	(SwapBufferLoc_SMC),hl
	ld	a,(menuSel)
	cp	a,8
	ret	nz
	ld	sp,(saveSP)
	jp	PGRM_BEGIN
 
switchSel:
	ld	hl,erase_sprite
	ld	a,(menuSel)
	push	af
	call	drawSel
	pop	af
	neg
	ld	(menuSel),a
	ld	hl,cherry_sprite
	call	drawSel
	ret
 
drawSel:
	ld	bc,(98-19)*256
	ld	c,92+16-3+8
	add	a,c
	ld	c,a
	call	drawSprite
	ret