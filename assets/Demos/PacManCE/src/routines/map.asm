cpyMapOrig:
SelectedMap_SMC =$+1
	ld	hl,OrigMapData
	ld	de,MapData
	ld	bc,28*30
	ldir
	ret
DisplayMap:
	ld	hl,MapData
	ld	bc,0
DispMapLoop:
	ld	a,(hl)
	inc	hl
	push	hl
	push	bc
	call	findTile
	call	drawSprite
	pop	bc
	pop	hl
 
	ld	a,b
	add	a,8
	ld	b,a
	cp	a,224
	jr	c,DispMapLoop
	ld	b,0
	ld	a,c
	add	a,8
	ld	c,a
	cp	a,30*8
	jr	c,DispMapLoop
	ret
 
findTile:
	cp	a,55	    ; Blank one that you can't move through
	jr	nz,+_
	xor	a \	inc	a
_:
	ld	de,66   ; e = 66 bytes
	ld	d,a
	mlt	de
	ld	hl,blank_sprite-66
	add	hl,de
	ret

drawTileReal:
	push	af
	call	getTileReal
	pop	af
	jr	drawTileMap
 
putTileReal:
	push	af
	call	getTileReal
	pop	af
	jr	putTileMapKnown2
 
replaceTileReal:
	call	getTileReal
	jr	putTileMapKnown
 
putTileMap:
	push	af
	call	getTileMap  ; bc = xy
putTileMapKnown2:
	pop	af
putTileMapKnown:
	ld	(hl),a
drawTileMap:
	call	getRealFromTile8bpp
	call	findTile   ; hl -> tile
	call	drawSpriteDouble
	ret

; inputs: bc
; outputs: bc
getRealFromTile:
	push	hl
	or	a,a
	sbc	hl,hl
	ld	l,8
	ld	h,b
	mlt	hl
	ld	b,l
	ld	l,8
	ld	h,c
	mlt	hl
	ld	c,l
	pop	hl
	ret
 
getRealFromTile8bpp:
	push	hl
	or	a,a
	sbc	hl,hl
	ld	l,4
	ld	h,b
	mlt	hl
	ld	b,l
	ld	l,4
	ld	h,c
	mlt	hl
	ld	c,l
	pop	hl
	ret
 
; inputs: hl
; outputs: bc
getRealFromMap:
	ld	de,MapData
	or	a,a
	sbc	hl,de
	call	getTileFromMap
	call	getRealFromTile
	ret
 
; inputs: hl
; outputs: bc
getTileFromMap:
	push	hl
	ld	d,28
	call	HLdivD
	ld	c,l
	ld	b,a
	pop	hl
	ret
 
; bc = tile xy
; Gets a tile based on its tilemapped x and y locations
getTileMap: 
	or	a,a
	sbc	hl,hl
	push	de
	ld	h,28
	ld	l,c
	mlt	hl
	ld	de,0
	ld	e,b
	add	hl,de
	ld	de,MapData
	add	hl,de
	pop	de
	ld	a,(hl)   ; hl -> tile; a = tilenumber
	ret
 
; de = tile xy
getWalls:
	push	de
	call	getTileReal
	cp	a,SMALL_DOT
	jr	nz,eatDot
	call	rest
	ld	de,10
addscore:
	ld	hl,(score)
	add	hl,de
	ld	(score),hl
	call	drawScore
	ld	a,1
eatDot:
	cp	a,BIG_DOT
	jp	z,eatPowerPellet
	pop	de
	dec	a
	ret	z
	popCall()
	popCall()
	ret
 
getWallsGhost:
	push	de
	call	getTileReal
	pop	de
	cp	a,SMALL_DOT
	ret	z
	cp	a,BIG_DOT
	ret	z
	dec	a
	ret	z
	ex	af,af'
	ld	a,(currGhostData+8)
	or	a,a
	jr	z,+_
	ex	af,af'
	cp	a,3
	ret	z
_:
	ld	a,$FF
	popCall()
	popCall()
	ret
 
rest:
	ld	a,1
	call	putTileMapKnown
	ld	hl,numdotseaten
	inc	(hl)
	ld	a,(hl)
	cp	a,70
	call	z,initializefruit
	cp	a,170
	call	z,initializefruit
	cp	a,242           ; got all dots
	ret	nz
	popCall()		; pop call to this routine
	jp	LevelEnd