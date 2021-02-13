resetGhostSprites:
	call	clearGhostBuffers
	ld	hl,eyesdown_sprite
	ld	(orangeGhostSprite),hl
	ld	(pinkGhostSprite),hl
	ld	(blueGhostSprite),hl
	ld	(redGhostSprite),hl
	ret

resetPacManThings:
	call	clearPacBuffer
	ld	hl,PacManStartY
	ld	de,PacManY
	ld	bc,3
	ldir
	xor	a
	ld	(PacManDir),a  ; Start left
	ld	(keypress),a
	ld	(PacManSpriteCounter),a
	ld	hl,pacmansolid_sprite
	ld	(pacmanSprite),hl
	ret

resetScoreTmrs:
	ld	hl,s200tmr
	push	hl
	pop	de
	inc	de
	ld	(hl),a
	ld	bc,4
	ldir
	ret
 
resetTunnelSpeeds:
	ld	hl,redGhostint
	ld	de,redGhostData+7
	call	restoreSpeedT
	ld	hl,blueGhostint
	ld	de,blueGhostData+7
	call	restoreSpeedT
	ld	hl,pinkGhostint
	ld	de,pinkGhostData+7
	call	restoreSpeedT
	ld	hl,orangeGhostint
	ld	de,orangeGhostData+7
	call	restoreSpeedT
	ret
 
getGhostFrightTmr:
	ld	a,(currlevel)
	dec	a
	cp	a,18
	jr	c,+_
	xor	a
	ld	(frighttimerlvl),a
	ret
_:
	ld	de,0
	ld	hl,LevelFrightTimmings
	ld	e,a
	add	hl,de
	ld	a,(hl)
	ld	(frighttimerlvl),a
	ret
 
getspeedsforlvl:
	ld	de,0
	ld	a,(currLevel)
	cp	a,5
	jr	nc,yy
	ld	hl,level1ghostspeed
	dec	a
	ld	e,a
	add	hl,de
	ld	e,(hl)
yy:
	ld	hl,tmpspeeds
	ld	(hl),e
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),e
	inc	hl
	ld	(hl),e
	call	Reloadfromtmpspeeds
	ret
 
initializefruit:
	xor	a
	ld	(fruitTimer),a
	dec	a
	ld	(fruitON),a
	ld	bc,(106*256)+125
	ld	hl,(currFruitSprite)
	jp	drawSprite
 
clearGhostBuffers:
	ld	hl,redghostbuf
	call	clearGhostBuffer
	ld	hl,blueghostbuf
	call	clearGhostBuffer
	ld	hl,orangeghostbuf
	call	clearGhostBuffer
	ld	hl,pinkghostbuf
	call	clearGhostBuffer
 
	ld	hl,redGhostDataS
	ld	de,redGhostData
	ld	bc,40
	ldir
	ret
 
clearPacBuffer:
	ld	hl,PacManTempBuffer
	ld	bc,12+(256*13)
	jr	clearbuf
clearGhostBuffer:
	ld	bc,14+(256*14)
clearbuf:
	ld	(hl),bc
	inc	hl
	inc	hl
	push	hl
	pop	de
	inc	de
	mlt	bc
	ld	(hl),BLACK_COLOR
	ldir
	ret
 
drawBigDots:
	ld	hl,MapData
	ld	bc,840
_:
	push	bc
	ld	a,(hl)
	cp	a,BIG_DOT
	jr	nz,+_		; If a big dot; save it.
	push	hl
	ld	de,MapData
	or	a,a
	sbc	hl,de
	call	getTileFromMap
	call	getRealFromTile
BigBlink_sprite:
	ld	hl,bigdotpiece_sprite
	call	drawSprite
	pop	hl
_:
	inc	hl
	pop	bc
	dec	bc
	ld	a,b
	or	a,c
	jr	nz,--_
	ret
 
restartGame:
	call	clearVBuf2
	call	cpyMapOrig
	xor	a,a
	ld	(numdotseaten),a
resetLevel:
	call	DisplayMap
 
	call	resetTunnelSpeeds
	call	resetPacManThings
	call	resetGhostSprites
	call	resetScoreTmrs
 
	call	getspeedsforlvl
	call	getGhostFrightTmr
 
	call	drawPacman
 
	call	drawGhosts
 
	call	drawFruitBox
	call	getFruitSprite
	call	getFruitScore
 
	call	drawRemLives
 
	call	drawlevel
	call	drawScore
 
	drawSpr255(ready_sprite, 89, 128)
	printf(ScoreString, 256, 10)
	printf(LevelString, 256, 60)
 
	xor	a
	ld	(fruitsctmr),a
	ld	(scatterActivatedTimes),a
	ld	(ScatterModeON),a
	ld	(fruitON),a
	ld	(pressed2nd),a
 
	call	fullBufCpy
 
	xor	a   ; reset RTC timer
	ld	(0F30024h),a
	ld	a,%11000001
	ld	(0F30020h),a
 
	ld	b,1
_:   ; wait until timer is	set	to 0
	ld	a,(0F30020h)
 bit 6,a
	jr	nz,-_
_:
	ld	a,(0F30000h)
	dec	a
	jr	nz,-_
	djnz	--_
 
 eraseRect(89, 128, 46, 7)
	ret