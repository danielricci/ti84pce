animateDeath:
	popcall()
	popcall()
	ld	hl,s200tmr
	ld	a,(hl)
	or	a,a
	call	nz,erase200
	inc	hl
	ld	a,(hl)
	or	a,a
	call	nz,erase400
	inc	hl
	ld	a,(hl)
	or	a,a
	call	nz,erase800
	inc	hl
	ld	a,(hl)
	or	a,a
	call	nz,erase1600
	call	eraseFruit
	call	eraseFruitScore
 
	ld	b,11
	ld	hl,pacmandie_1_sprite
_:
	push	bc
	push	hl
	ld	bc,(PacManY)
	call	drawSprite
	call	fullBufcpy
	call	longishdelay
	pop	hl
	pop	bc
	ld	de,(15*12)+2
	add	hl,de
	djnz	-_
 
	ld	h,14
	ld	l,h
	ld	bc,(PacManY)
	call	drawClearingRect
 
	call	fullBufcpy
	call	longishdelay
	nop
	nop
	ld	a,(lives)
	dec	a
	cp	a,$FF
	jp	z,GameOver
	ld	(lives),a
	call	resetLevel
	jp	mainGameLoop
 
pacmanR:
	ld	de,(PacManY)
	push	de
	ld	hl,3+(11*256)
	add	hl,de
	ex	de,hl
	call	getWalls
	ld	a,e
	add	a,7
	ld	e,a
	call	getWalls
	pop	de
	inc	d
	ld	(PacManY),de
	ld	a,4
	jp	getnewSprite
pacmanL:
	ld	de,(PacManY)
	push	de
	inc	d
	inc	d
	inc	e
	inc	e
	inc	e
	call	getWalls
	ld	a,e
	add	a,7
	ld	e,a
	call	getWalls
	pop	de
	dec	d
	ld	(PacManY),de
	ld	a,2
	jp	getnewSprite
pacmanU:
	ld	de,(PacManY)
	push	de
	inc	e
	inc	e
	inc	d
	inc	d
	inc	d
	call	getWalls
	ld	a,d
	add	a,7
	ld	d,a
	call	getWalls
	pop	de
	dec	e
	ld	(PacManY),de
	ld	a,8
	jp	getnewSprite
pacmanD:
	ld	de,(PacManY)
	push	de
	ld	hl,11+(3*256)
	add	hl,de
	ex	de,hl
	call	getWalls
	ld	a,d
	add	a,7
	ld	d,a
	call	getWalls
	pop	de
	inc	e
	ld	(PacManY),de
	ld	a,1
	jp	getnewSprite
 
drawPacman:
	ld	hl,PacManY
	call	switchSides
	ld	de,PacManTempBuffer
	ld	hl,(pacmanSprite)
	call	getSprite
	ld	bc,(PacManY)
	ld	hl,(pacmanSprite)
	jp	drawSprite
 
erasePacman:
	ld	bc,(PacManY)
	ld	hl,PacManTempBuffer
	jp	drawSprite
 
getnewSprite:
	ld	(PacManDir),a
	call	getNextPacManSprite
	ld	e,a
	ld	hl,gotit
	push	hl
	ld	hl,pacmansolid_sprite
	ld	a,(PacManDir)
	sra	a
	jr	z,downsprite
	sra	a
	jr	z,leftsprite
	sra	a
	jr	z,rightsprite
upsprite:
	call	ldae
	ld	hl,pacmanup1_sprite
	dec	a
	ret	z
	dec	a
	dec	a
	ret	z
	ld	hl,pacmanup2_sprite
	ret
downsprite:
	call	ldae
	ld	hl,pacmandown1_sprite
	dec	a
	ret	z
	dec	a
	dec	a
	ret	z
	ld	hl,pacmandown2_sprite
	ret
rightsprite:
	call	ldae
	ld	hl,pacmanright1_sprite
	dec	a
	ret	z
	dec	a
	dec	a
	ret	z
	ld	hl,pacmanright2_sprite
	ret
leftsprite:
	call	ldae
	ld	hl,pacmanleft1_sprite
	dec	a
	ret	z
	dec	a
	dec	a
	ret	z
	ld	hl,pacmanleft2_sprite
	ret
ldae:
	ld	a,e
	or	a,a
	ret	nz
	pop	de
	pop	de
gotit:
	ld	(pacmanSprite),hl
	ret
 
getNextPacManSprite:
	ld	a,(PacManSpriteCounter)
	inc	a
	cp	a,4
	jr	nz,+_
	xor	a
_:
	ld	(PacManSpriteCounter),a
	ret
 
; reverses ghosts' directions
reverseDir:
	ld	a,2
	xor	(hl)
	ld	(hl),a
	ret
   
reverseAllGhostdirections:
	ld	hl,redGhostData+4
	ld	b,4
_:
	inc	hl
	inc	hl
	ld	a,(hl)
	dec	hl
	dec	hl
	cp	a,EYES_ACTIVE
	call	nz,reverseDir
	ld	de,GHOST_DATA_SIZE
	add	hl,de
	djnz	-_
	ret
   
eatPowerPellet:
	push	hl
	push	bc
	ld	hl,redGhostData+6
	ld	de,tmpspeeds
	ld	b,4
_:
	push	de
 	ld	a,(hl)
 	or	a,a
 	jr	nz,+_
 	ld	(hl),1
 	dec	hl
 	dec	hl
 	call	reverseDir
 	inc	hl
 	inc	hl
 	inc	hl
 	ld	a,(hl)
 	ld	(de),a
 	ld	(hl),2
 	dec	hl
_:
 	ld	de,GHOST_DATA_SIZE
 	add	hl,de
	pop	de
	inc	de
	djnz	--_
	xor	a
	ld	(frightTimer),a
	ld	(needFlash),a
	ld	(amtGhostsEaten),a
	call	resetTunnelSpeeds
	ld	a,$FF
	ld	(FrightModeON),a
	ld	a,(frighttimerlvl)
	push	af
 	or	a,a
 	call	z,MakeGhostsBad
	pop	af
	dec	a   ; If 1 second
	jr	nz,+_
	call	FlashGhosts
_:
 
	pop	bc
	pop	hl
 
	call	rest
	ld	de,50
	jp	addscore
 
chkifaddlife:
	ld	a,(addedlife)
	or	a,a
	ret	nz
	ld	hl,(score)
	ld	de,10000
	call	cphlde
	ret	c
	cpl
	ld	(addedlife),a
	ld	hl,lives
	inc	(hl)
	jp	drawRemLives

drawRemLives:
	ld	hl,pacmanleft1_sprite
	ld	a,(lives)
	cp	a,1
	jr	nc,+_
	ld	hl,erase_sprite
_:	ld	bc,(136/2)+((250/2)*256)
	call	drawSpriteDouble
	ld	hl,pacmanleft1_sprite
	ld	a,(lives)
	cp	a,2
	jr	nc,+_
	ld	hl,erase_sprite
_:	ld	bc,(136/2)+((270/2)*256)
	call	drawSpriteDouble
	ld	hl,pacmanleft1_sprite
	ld	a,(lives)
	cp	a,3
	jr	nc,+_
	ld	hl,erase_sprite
_:	ld	bc,(136/2)+((290/2)*256)
	jp	drawSpriteDouble
 
movePacMan:
	call	chkifaddlife
	ld	a,(PacManDir)
	ld	e,a
 
	ld	a,(0F5001Eh)
	or	a,a
	jr	z,skipkeysave
	ld	(keypress),a
skipkeysave:
	ld	a,(keypress)
	cp	a,e  ; If the same, skip
	jr	z,+_
	dec	a
	call	z,pacmanD
	ld	a,(keypress)
	cp	a,2
	call	z,pacmanL
	ld	a,(keypress)
	cp	a,4
	call	z,pacmanR
	ld	a,(keypress)
	cp	a,8
	call	z,pacmanU
_:	ld	a,(PacManDir)
	sra	a
	jp	z,pacmanD
	sra	a
	jp	z,pacmanL
	sra	a
	jp	z,pacmanR
	jp	pacmanU
