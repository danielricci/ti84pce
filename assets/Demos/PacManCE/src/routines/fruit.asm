getFruitSprite:
	ld	hl,FruitLvlTypes
	ld	de,0
	ld	a,(currlevel)
	dec	a
	cp	a,12
	jr	c,+_
	ld	hl,key_sprite
	jr	++_
_:
	ld	e,a
	add	hl,de
	ld	l,(hl)
	ld	h,(13*14)+2
	mlt	hl
	ld	de,cherry_sprite
	add	hl,de
_:
	ld	(currFruitSprite),hl
	ret
 
getFruitScore:
	ld	hl,FruitLvlScores
	ld	de,0
	ld	a,(currlevel)
	dec	a
	cp	a,12
	jr	c,+_
	ld	de,5000
	jr	++_
_:
	ld	e,a
	add	hl,de
	ld	e,(hl)
	ld	d,100
	mlt	de
_:
	ld	(currFruitScore),de
 
drawFruitBox:
	ld	de,244
	ld	a,158
	ld	b,60
	call	drawHLine
	ld	de,245
	ld	a,159
	ld	b,58
	call	drawHLine
	ld	de,244
	ld	a,218
	ld	b,60
	call	drawHLine
	ld	de,245
	ld	a,217
	ld	b,58
	call	drawHLine
	ld	de,244
	ld	a,158
	ld	b,60
	call	drawVLine
	ld	de,245
	ld	a,159
	ld	b,58
	call	drawVLine
	ld	de,242+62
	ld	a,158
	ld	b,60
	call	drawVLine
	ld	de,243+60
	ld	a,159
	ld	b,58
	call	drawVLine
 
	drawSpr8bpp(cherry_sprite, 250, 164)
	ld	a,(currlevel)
	cp	a,2
	ret	c
	drawSpr8bpp(strawberry_sprite, 268, 164)
	cp	a,3
	ret	c
	drawSpr8bpp(orange_sprite, 268+18, 164)
	cp	a,5
	ret	c
	drawSpr8bpp(apple_sprite, 250, 182)
	cp	a,7
	ret	c
	drawSpr8bpp(thingy_sprite, 268, 182)
	cp	a,9
	ret	c
	drawSpr8bpp(otherthingy_sprite, 268+18, 182)
	cp	a,11
	ret	c
	drawSpr8bpp(bell_sprite, 250+11, 164+18+18)
	cp	a,13
	ret	c
	drawSpr8bpp(key_sprite, 250+10+18, 164+18+18)
	ret

drawFruitScore:
	ld	hl,DrawMe
	push	hl
	ld	hl,(currfruitscore)
	ld	bc,s100fruit_sprite
	ld	de,100
	call	cphlde
	ret	z
	ld	bc,s300fruit_sprite
	ld	de,300
	call	cphlde
	ret	z
	ld	bc,s500fruit_sprite
	ld	de,500
	call	cphlde
	ret	z
	ld	bc,s700fruit_sprite
	ld	de,700
	call	cphlde
	ret	z
	ld	bc,s1000fruit_sprite
	ld	de,1000
	call	cphlde
	ret	z
	ld	bc,s2000fruit_sprite
	ld	de,2000
	call	cphlde
	ret	z
	ld	bc,s3000fruit_sprite
	ld	de,3000
	call	cphlde
	ret	z
	ld	bc,s5000fruit_sprite
	ret
DrawMe:
	push	bc
	pop	hl
	ld	bc,128+(103*256)
	call	drawSprite
	ld	a,2
	ld	(fruitsctmr),a
	ret
 
chkFruitCollision:
	ld	a,(fruitON)
	or	a,a
	ret	z
	ld	bc,(106*256)+125
	ld	hl,(currfruitsprite)
	call	drawSprite
	ld	de,(PacManY)
	call	getTileReal ; Get the current tile pacman is on
	ld	a,13
	cp	a,b
	ret	nz
	ld	a,15
	cp	a,c
	ret	nz    ; if we get here; it means we ate a fruit
	ld	hl,(score)
	ld	de,(currFruitScore)
	add	hl,de
	ld	(score),hl
	call	drawScore
	call	eraseFruit
	call	drawFruitScore
	ret
eraseFruit:
	ld	h,14
	ld	l,h
	ld	bc,(106*256)+125
	call	drawClearingRect
	xor	a
	ld	(fruitON),a
	ld	(fruitTimer),a
	ret
 
eraseFruitScore:
	ld	h,21
	ld	l,8
	ld	bc,128+(103*256)
	call	drawClearingRect
	ret
 
doSecondStuff:
	call	chkGhostTmrs
	ld	a,(s200tmr)
	or	a,a
	jr	z,+_
	dec	a
	ld	(s200tmr),a
	call	z,erase200
_:
	ld	a,(s400tmr)
	or	a,a
	jr	z,+_
	dec	a
	ld	(s400tmr),a
	call	z,erase400
_:
	ld	a,(s800tmr)
	or	a,a
	jr	z,+_
	dec	a
	ld	(s800tmr),a
	call	z,erase800
_:

	ld	a,(s1600tmr)
	or	a,a
	jr	z,+_
	dec	a
	ld	(s1600tmr),a
	call	z,erase1600
_:
	ld	a,(fruitsctmr)
	or	a,a
	jr	z,+_
	dec	a
	ld	(fruitsctmr),a
	call	z,eraseFruitScore
_:
	ld	a,(fruitON)
	or	a,a
	ret	z
	ld	hl,fruitTimer
	inc	(hl)
	ld	a,(hl)
	cp	a,10
	call	z,eraseFruit
	ret