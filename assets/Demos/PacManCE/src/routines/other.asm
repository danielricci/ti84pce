getRand:
	ld	a,r
 and a,2 
	cp	a,2
	ret

CdivD:
	ld	b,8
	xor	a,a
	sla	c
 rla
	cp	a,d
	jr	c,$+4
	inc	c
	sub	a,d
	djnz	$-8
	or	a,a
	ret

HLdivD:            ; HL = HL ÷ D, A = remainder
 	xor	   A         ; Clear upper eight bits of AHL
 	ld	    B, 24      ; Sixteen bits in dividend
_loop:
 	add	   HL, HL     ; Do a	slaHL
    RLA              ; This moves the upper bits of the dividend into A
 	jr	    C, _overflow
 	cp	a,    D         ; Check if we can subtract the divisor
 	jr	    C, _skip   ; Carry means D > A
_overflow:
 	sub	a,   D         ; Do subtraction for real this time
 	inc	   L         ;	set	bit 0 of quotient
_skip:
 	djnz	  _loop
 	ret
    
cphlde:
	or	a,a
	sbc	hl,de
	add	hl,de
	ret
 
getTileReal:
	push	de
	push	de
	pop	bc
	ld	d,8
	ld	l,b
	call	CdivD
	ld	e,c
	ld	c,l
	call	CdivD
	ld	d,c
	push	de
	pop	bc
	call	getTileMap
	pop	de
	ret
 
extractImage:
	push	bc
  ldi
  ldi
	ld	bc,(hl)
	inc	hl
	inc	hl
	inc	hl
	call	decompress
	pop	bc
	ret
 
chkIfTick:
	ld	a,(currsec)
	ld	hl,$F30000
	cp	a,(hl)
	ret	z
	ld	a,(hl)
	ld	(currsec),a
	xor	a \	inc	a
	ret
 
decompressSprites:
	ld	hl,blank_sprite_data
	ld	de,plotsscreen
	ld	b,NUM_SPRITES
decompressI:
	call	extractImage
	djnz	decompressI
	ret
 
;Input:
;hl = adress of compressed data.
;de = adress you want to store to
;bc = size of compressed data
decompress:
	push	bc
	ld	a,(hl)
  and $80  ; if 0, that means that we can just grab the next bytes and do a direct copy -- fast.
	jr	z,uncompressed_bytes
	ld	a,(hl)
	sub	a,$7F  ; otherwise, get the number of bytes to copy
	ld	b,a
	inc	hl
	ld	a,(hl)
decompress_loop:
	ld	(de),a
	inc	de
	djnz	decompress_loop
	pop	bc
	inc	hl
	dec	bc
from_uncompressed_byte:
	dec	bc
	ld	a,b
	or	a,c
	jr	nz,decompress
	ret
uncompressed_bytes:
	ld	bc,0
	ld	c,(hl) ; hl->data
	inc	c
	inc	hl
	ldir
	pop	bc
	jr	from_uncompressed_byte
 
;--------------------------------------------------------------------

drawlevel:
	or	a,a
	sbc	hl,hl   ; hl = 8-bit score
	ld	a,(currLevel)
	ld	l,a
	ld	de,tmpStr  ; de = converted string loc
	call	Num2String 
	printf(tmpStr+4, 264, 80)
	ret
 
drawScore:
	ld	hl,(score)   ; hl = 8-bit score
	ld	de,tmpStr  ; de = converted string loc
	call	Num2String
	printf(tmpStr, 249, 30)
	ret
 
Num2String:
	call	str
	xor	a,a
	ld	(de),a
	ret
 
str:
	ld	bc,-1000000
	call	Num13
	ld	bc,-100000
	call	Num13
	ld	bc,-10000
	call	Num13
	ld	bc, -1000
	call	Num13
	ld	bc, -100
	call	Num13
	ld	c, -10
	call	Num13
	ld	c, b
Num13:
	ld	a, '0'-1
Num21:
	inc	a
	add	hl, bc
	jr	c, Num21
	sbc	hl, bc
	ld	(de), a
	inc	de
	ret
 
longishdelay:
	ld	bc,$FFFF
delay: 
	push	hl
	pop	hl
	push	hl
	pop	hl
	dec	c
	jr	nz,delay
	djnz	delay
	ret
 
sqrt_hl:
sqrt:
	ld	a,$ff
	ld	de,1
sqrtloop:
	inc	a
	dec	e
	dec	de
	add	hl,de
	jr	c,sqrtloop
	ret	
 
AbsA:
	bit	7,a
	ret	z
	neg
	ret
 
saveSP:
	.dl 0

switchSides:
	ld	bc,(hl)
	ld	a,b
	cp	a,-1
	jr	c,+_
	ld	b,224-8-4
	ld	(hl),bc
	ret
_:
	cp	a,224-8-3
	ret	c
	ld	b,0
	ld	(hl),bc
	ret
 
switch:
	ld	hl,toggleCoins
	ld	a,(hl)
	cpl
	ld	(hl),a
	ret
 
invertScreen:
	ld	b,2
VV:	push	bc
	ld	hl,vBuf2
	ld	bc,lcdWidth*lcdHeight
_:	ld	a,(hl)
	cp	a,3
	jr	nz,+_
	ld	(hl),6
_:	inc	hl
	dec	bc
	call	_ChkBCis0
	jr	nz,--_
	call	fullBufCpy
	ld	hl,vBuf2
	ld	bc,lcdWidth*lcdHeight
_:	ld	a,(hl)
	cp	a,6
	jr	nz,+_
	ld	(hl),3
_:	inc	hl
	dec	bc
	call	_ChkBCis0
	jr	nz,--_
	call	fullBufCpy
	pop	bc
	djnz	VV
	ret
	
FlashInsertCoin:
	call	checkIfHacked
	xor	a,a
	ld	(toggleCoins),a
	ld	(0F30024h),a
	ld	a,%11000001
	ld	(0F30020h),a
	call	fullBufCpy
_:
	call	chkIfTick
	call	nz,switch
	ld	a,(toggleCoins)
	or	a,a
	jr	z,+_
	eraseRect(122, 124, 100, 8)
	jr	++_
_:	printf(InsertCoinString, 123, 124)
_:	call	fullBufCpy
	call	_getcsc
	cp	a,sk5
	jr	z,changeMap
	cp	a,skDel
	jp	z,FullExit
	cp	a,skClear
	jp	z,FullExit
	cp	a,skEnter
	ret	z
	cp	a,sk2nd
	jr	nz,---_
	ret

changeMap:
	ld	hl,OtherMapData
	ld	(SelectedMap_SMC),hl
	printf(HackedString, 0, 0)
	jr	---_

checkIfHacked:
	ld	hl,OrigMapData
	ld	de,(SelectedMap_SMC)
	call	_cphlde
	ld	hl,HackedString
	ld	bc,0
	call	nz,drawString
	ret
	
drawHelpScreen:
	call	clearVBuf2
	call	checkIfHacked
	drawSpr255(pacmanlogo_sprite, 83, 44)
	ld	a,RED_COLOR
	ld	(ForeColor),a
	printf(BlinkyTextString, 83, 100)
	ld	a,PINK_COLOR
	ld	(ForeColor),a
	printf(PinkyTextString, 83, 116)
	ld	a,BLUE_COLOR
	ld	(ForeColor),a
	printf(InkyTextString, 83, 132)
	ld	a,ORANGE_COLOR
	ld	(ForeColor),a
	printf(ClydeTextString, 83, 148)
 
	ld	a,WHITE_COLOR
	ld	(ForeColor),a
	printf(TenPTSString, 83, 148+32)
	printf(FiftyPTSString, 83, 148+32+16)
 
	printf(Times1String, 194, 168)
	printf(Times2String, 194, 168+14)
	printf(Times3String, 194, 168+14+14)
	printf(Times4String, 194, 168+14+14+14)
 
	drawSpr255(ghostscared_sprite, 175, 148+38)
 
	printf(BonusString, 83, 148+32+16+32)
 
	drawSpr255(pacmanright1_sprite, 64, 148+32+16+32-3)
	drawSpr255(ghostred_sprite, 64, 97)
	drawSpr255(eyesdown_sprite, 64, 97)
	drawSpr255(ghostpink_sprite, 64, 113) 
	drawSpr255(eyesdown_sprite, 64, 113)
	drawSpr255(ghostblue_sprite, 64, 129)
	drawSpr255(eyesdown_sprite, 64, 129)
	drawSpr255(ghostorange_sprite, 64, 145)
	drawSpr255(eyesdown_sprite, 64, 145)
 
	drawSpr255(dotpiece_sprite, 64, 148+32)
	drawSpr255(bigdotpiece_sprite, 64, 148+32+16)
 
	call	fullBufCpy
	jp	waitfor2ND