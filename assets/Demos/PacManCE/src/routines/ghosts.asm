targetnestInky:
	ld	bc,32+(32*256)
	jr	t
targetnestClyde:
	ld	bc,32
	jr	t
targetnestPinky:
	ld	bc,-8
	jr	t
targetnestBlinky:
	ld	bc,-8+(28*256)
	jr	t
targetHome:
	ld	bc,12+(13*256)
t:	ld	(targetY),bc
	ret
 
getTargetBlinky:
	ld	a,(redGhostData+6)
	cp	a,EYES_ACTIVE
	jp	z,targetHome
	ld	a,(FrightModeON)
	or	a,a
	jp	nz,getRandomTarget
	ld	a,(ScatterModeON)
	or	a,a
	jp	z,targetnestBlinky
getTargetPacMan:
	ld	hl,(PacManY) ; get X and Y tiles
	ld	de,7+(7*256)
	add	hl,de
	ex	de,hl
	call	getTileReal
	ld	(targetY),bc
	ret
 
getTargetPinky:
	ld	a,(pinkGhostData+6)
	cp	a,EYES_ACTIVE
	jp	z,targetHome
	ld	a,(FrightModeON)
	or	a,a
	jp	nz,getRandomTarget
	ld	a,(ScatterModeON)
	or	a,a
	jr	z,targetnestPinky
	call	getTargetPacMan
	ld	hl,t
	push	hl
	ld	a,(PacManDir)
	or	a,a
	jp	z,detLeft
	dec	a
	jp	z,detDown
	dec	a
	jp	z,detRight
	jp	detUp
 
getTargetInky:   ; Only one not like the orignal, because it's wierd.
	ld	a,(blueGhostData+6)
	cp	a,EYES_ACTIVE
	jp	z,targetHome
	ld	a,(FrightModeON)
	or	a,a
	jp	nz,getRandomTarget
	ld	a,(ScatterModeON)
	or	a,a
	jp	z,targetnestInky
	call	getTargetPacMan
	call	getRand
	jr	z,+_
	ld	a,b
	sub	a,10
	ld	b,a
	jr	++_
_:
	ld	a,c
	add	a,10
	ld	c,a
_:
	ld	(targetY),bc
	ret
 
getRandomTarget:
	ld	b,30
	call	irandom
	push	af
	ld	b,30
	call	irandom
	pop	bc
	ld	c,a
	call	_SetBCUto0
	jp	t
 
;-----> Generate a random number
; input b=upper bound
; ouput a=answer 0<=a<b
; all registers are preserved except: af and bc
irandom:
	push	hl
	push	de
	ld	hl,(randData)
	ld	a,r
	ld	d,a
	ld	e,(hl)
	add	hl,de
	add	a,l
	xor	h
	ld	(randData),hl
	sbc	hl,hl
	ld	e,a
	ld	d,h
randomLoop:
	add	hl,de
	djnz	randomLoop
	ld	a,h
	pop	de
	pop	hl
	ret
	
getTargetClyde:
	ld	a,(orangeGhostData+6)
	cp	a,EYES_ACTIVE
	jp	z,targetHome
	ld	a,(FrightModeON)
	or	a,a
	jp	nz,getRandomTarget
	ld	a,(ScatterModeON)
	or	a,a
	jp	z,targetnestClyde
	call	getTargetPacMan
	ld	de,(curTileY)
	call	computetarget
	call	sqrt_hl  ; output in a
	cp	a,8   ; If greater than 8, target pacman. Else, target 0,30 :: A < 8, C is	set	and Z is reset
	jp	c,targetnestClyde
	ret
 
detRight:
	ld	a,b
	sub	a,4
	ld	b,a
	ret
detDown:
	ld	a,c
	add	a,4
	ld	c,a
	ret
detUp:
	ld	a,c
	sub	a,4
	ld	c,a
detLeft:
	ld	a,b
	add	a,4
	ld	b,a
	ret

ghostData:
	.db 14,14
 
drawGhosts:
	call	drawGhostScore
	call	getBehindGhosts
 
	ld	de,redGhostData
	ld	hl,ghostred_sprite
	ld	ix,redGhostSprite-3
	ld	b,4
_:
	push	bc
	push	hl
	push	de
  	ex	de,hl
 	ld	bc,6
 	add	hl,bc
 	ld	a,(hl)
 	ld	bc,-6
 	add	hl,bc
 	ld	bc,(hl)
 	cp	a,EYES_ACTIVE
 	jr	z,ml
 	push	bc
   	ex	de,hl
  	call	drawSprite
 	pop	bc
ml:
 	inc	ix
 	inc	ix
 	inc	ix
 	push	ix
 	pop	hl
 	ld	hl,(hl)
 	call	drawSprite
	pop	hl
	ld	de,GHOST_DATA_SIZE
	add	hl,de
 	ex	de,hl
	pop	hl
	ld	bc,(14*14)+2
	add	hl,bc
	pop	bc
	djnz	-_
	ret
 
getBehindGhosts:
	ld	hl,redGhostData
	ld	de,redghostbuf
	ld	b,4
_:
	push	bc
	push	hl
	push	de
 	ld	bc,(hl)
 	ld	hl,ghostData
 	call	getSprite
 	pop	de
	ld	hl,16*16
	add	hl,de
 	ex	de,hl
	pop	hl
	ld	bc,GHOST_DATA_SIZE
	add	hl,bc
	pop	bc
	djnz	-_
	ret
 
eraseGhosts:
	ld	hl,redGhostData
	ld	de,redghostbuf
	ld	b,4
_:
	push	bc
	push	hl
	push	de
 	ld	bc,(hl)
  	ex	de,hl
 	call	drawSprite
	pop	de
	ld	hl,16*16
	add	hl,de
 	ex	de,hl
	pop	hl
	ld	bc,GHOST_DATA_SIZE
	add	hl,bc
	pop	bc
	djnz	-_
	ret
 
getGhostSprite:
	ex	af,af'
	ld	a,(currGhostData+6)
	or	a,a
	jr	z,Norm
	dec	a
	dec	a
	jr	z,eyes
	ld	a,(needFlash)
	or	a,a
	jr	z,Norm
	ex	af,af'
	or	a,a
	jr	z,white
Norm:
	call	eyes
	ld	a,(currGhostData+6)
	or	a,a
	ret	z
scared:
	ld	bc,ghostscared_sprite
	ld	(hl),bc
	ret
white:
	push	bc
	pop	hl
	ld	bc,ghostwhite_sprite
	ld	(hl),bc
	ret
eyes:
	ld	hl,eyesleft_sprite
	push	bc
	call	getGhostSprite2
	add	hl,de
	push	hl
	pop	bc
	pop	hl
	ld	(hl),bc
	ret
 
getGhostSprite2:
	ld	de,0
	ld	a,(currGhostData+4)
	or	a,a
	ret	z
	ld	de,14*9+2
	dec	a
	ret	z
	ld	de,(14*9+2)*2
	dec	a
	ret	z
	ld	de,(14*9+2)*3
	ret
 
kk:
	ld	a,(currGhostData+6)
	cp	a,2   ; This means that the ghost is still in eye mode -- So moves twice as fast.
	jr	nz,+_
	call	+_
_:
	ld	a,(currGhostData+4)
	or	a,a
	jp	z,movL
	dec	a
	jp	z,movD
	dec	a
	jp	z,movR
	jp	movU

stoleft:
	xor	a,a
	ld	(leftopen),a
	ret
storight:
	xor	a,a
	ld	(rightopen),a
	ret
stoup:
	xor	a,a
	ld	(upopen),a
	ret
stodown:
	xor	a,a
	ld	(downopen),a
	ret
 
DispA1place:
	push	hl
	or	a,a
	sbc	hl,hl
	ld	l,a
	push	de
 	push	bc
  	ld	de,tmpStr  ; de = converted string loc
  	call	Num2String
  	ld	hl,tmpStr+6
  	pop	bc
  	call	drawString
	pop	de
	pop	hl
	ret
 
DispA:
	push	hl
	or	a,a
	sbc	hl,hl
	ld	l,a
	push	de
 	push	bc
  	ld	de,tmpStr  ; de = converted string loc
  	call	Num2String
  	ld	hl,tmpStr+4
  	pop	bc
  	call	drawString
	pop	de
	pop	hl
	ret
 
DispHL:     ; hl = 8-bit score
	push	hl
	push	de
	push	bc
 	ld	de,tmpStr  ; de = converted string loc
 	push	de
 	call	Num2String
 	pop	hl ; hl points to converted string
 	pop	bc
 	call	drawString
	pop	de
	pop	hl
	ret

movR:
	ld	de,(currGhostData)
	push	de
	ld	a,d
	add	a,11
	ld	d,a
	inc	e
	inc	e
	inc	e
	call	getWallsGhost
	ld	a,e
	add	a,7
	ld	e,a
	call	getWallsGhost
	pop	de
	inc	d
	ld	(currGhostData),de
	ld	hl,currGhostData
	call	switchSides
	xor	a
	ret
movL:
	ld	de,(currGhostData)
	push	de
	inc	d
	inc	d
	inc	e
	inc	e
	inc	e
	call	getWallsGhost
	ld	a,e
	add	a,7
	ld	e,a
	call	getWallsGhost
	pop	de
	dec	d
	ld	(currGhostData),de
	ld	hl,currGhostData
	call	switchSides
	xor	a
	ret
movU:
	ld	de,(currGhostData)
	push	de
	inc	e
	inc	e
	inc	d
	inc	d
	inc	d
	call	getWallsGhost
	ld	a,d
	add	a,7
	ld	d,a
	call	getWallsGhost
	pop	de
	dec	e
	ld	(currGhostData),de
	ld	hl,currGhostData
	call	switchSides
	xor	a
	ret
movD:
	ld	de,(currGhostData)
	push	de
	ld	a,e
	add	a,11
	ld	e,a
	inc	d
	inc	d
	inc	d
	call	getWallsGhost
	ld	a,d
	add	a,7
	ld	d,a
	call	getWallsGhost
	pop	de
	inc	e
	ld	(currGhostData),de
	ld	hl,currGhostData
	call	switchSides
	xor	a,a
	ret
 
computetarget:
	push	de
	pop	bc
	ld	a,(targetY)
	sub	a,c
	call	AbsA
	ld	l,a
	ld	h,l
	mlt	hl
	ex	de,hl
	ld	a,(targetX)
	sub	a,b
	call	AbsA
	ld	l,a
	ld	h,l
	mlt	hl
	add	hl,de ; hl now hold the linear distance between the current X Y and the target X Y
	ret

getDistances:
	ld	hl,$FFFF
	ld	a,(upopen)
	or	a,a
	jr	z,f
	ld	de,(curTileY)
	dec	e  ; up
	call	computetarget
f:
	ld	(updist),hl
 
	ld	hl,$FFFF
	ld	a,(downopen)
	or	a,a
	jr	z,ff
	ld	de,(curTileY)
	inc	e  ; up
	call	computetarget
ff:
	ld	(downdist),hl
 
	ld	hl,$FFFF
	ld	a,(leftopen)
	or	a,a
	jr	z,fff
	ld	de,(curTileY)
	dec	d ; up
	call	computetarget
fff:
	ld	(leftdist),hl
 
	ld	hl,$FFFF
	ld	a,(rightopen)
	or	a,a
	jr	z,ffff
	ld	de,(curTileY)
	inc	d  ; up
	call	computetarget
ffff:
	ld	(rightdist),hl
	ret
 
getTileOfGhost: 
	ld	hl,(currGhostData) ; get X and Y tiles
	ld	de,7+(7*256)
	add	hl,de
	ex	de,hl
	call	getTileReal
	ld	(curTileY),bc
	ret
 
hdetect:
	ld	a,h
	cp	a,b
	ccf
	ret	nc
	cp	a,d
	ret	nc
	ld	a,l
	cp	a,c
	ccf
	ret	nc
	cp	a,e
	ret
 
chkColl:
	push	bc
	ld	hl,(PacManY) ; get X and Y tiles
	ld	de,7+(7*256)
	add	hl,de
	ex	de,hl
	ld	hl,0
	ld	h,d
	ld	l,e ;	pop	call
	pop	bc ;	push	call
	push	hl
	push	bc
	pop	hl
	ld	de,14+(256*14)
	add	hl,de
	ex	de,hl
	pop	hl
	call	hdetect
	ret
 
saveSpeed:
	ld	(PTR),hl
	ld	a,(hl)
	cp	a,EYES_ACTIVE
	push	af
	ld	(hl),EYES_ACTIVE
	inc	hl   ; +7
	ld	(hl),0  ; makes it go at 100% speed
	inc	hl
	inc	hl
	ld	a,(de)
	ld	(hl),a
	pop	af
	ret	z
	ld	a,(amtGhostsEaten)
	inc	a
	ld	(amtGhostsEaten),a
	ld	b,a
	ld	hl,200
	dec	a
	push	af
	jr	z,gotitscore
	ld	b,a
_:
	add	hl,hl
	djnz	-_
gotitscore:
	ld	de,(score)
	add	hl,de
	ld	(score),hl
	call	drawScore
	ld	de,3
	ld	bc,s200tmr
	ld	hl,s200loc
	pop	af
	jr	z,+_
	inc	bc
	add	hl,de
	dec	a
	jr	z,+_
	inc	bc
	add	hl,de
	dec	a
	jr	z,+_
	inc	bc
	add	hl,de
_:
	push	hl
	ld	hl,(PTR)
	ld	de,-6
	add	hl,de
	ld	de,(hl)
	dec	d
	inc	e
	inc	e
	inc	e
	pop	hl
	ld	(hl),de
	push	bc
	pop	hl
	ld	(hl),2
	ret
 
chkCollisionRed:
	ld	bc,(redGhostData)
	call	chkColl   ; If C, we hit it.
	ret	nc
	ld	a,(redGhostData+6)
	or	a,a   ; if 1, then eat the ghost
	jp	z,animateDeath   ; Else, quit for now
	ld	hl,redGhostData+6
	ld	de,tmpspeeds
	jp	saveSpeed
 
chkCollisionBlue:
	ld	bc,(blueGhostData)
	call	chkColl
	ret	nc
	ld	a,(blueGhostData+6)
	or	a,a   ; if 1, then eat the ghost
	jp	z,animateDeath   ; Else, quit for now
	ld	hl,blueGhostData+6
	ld	de,tmpspeeds+1
	jp	saveSpeed
 
chkCollisionPink:
	ld	bc,(pinkGhostData)
	call	chkColl
	ret	nc
	ld	a,(pinkGhostData+6)
	or	a,a   ; if 1, then eat the ghost
	jp	z,animateDeath   ; Else, quit for now
	ld	hl,pinkGhostData+6
	ld	de,tmpspeeds+2
	jp	saveSpeed

chkCollisionOrange:
	ld	bc,(orangeGhostData)
	call	chkColl
	ret	nc
	ld	a,(orangeGhostData+6)
	or	a,a   ; if 1, then eat the ghost
	jp	z,animateDeath   ; Else, quit for now
	ld	hl,orangeGhostData+6
	ld	de,tmpspeeds+3
	jp	saveSpeed
 
getElroySpeed:
	ld	hl,redGhostData+7
	ld	a,(redGhostData+6)
	or	a,a
	jr	z,ssL
	ld	hl,tmpspeeds
ssL:
	ld	a,(currlevel)
	cp	a,4
	jr	nc,alll
	cp	a,3
	jr	z,lvl3
	cp	a,2
	jr	z,lvl22
lvl1:
	ld	a,(numdotseaten)
	cp	a,242-20
	ret	c
	ld	(hl),5
	ret
lvl22:
	ld	a,(numdotseaten)
	cp	a,242-30
	ret	c
	ld	(hl),6
	ret
lvl3:
	ld	a,(numdotseaten)
	cp	a,242-40
	ret	c
	ld	(hl),7
	ret
alll:
	ld	a,(numdotseaten)
	cp	a,80
	ret	c
	ld	(hl),0
	ret

moveBlinky:
	call	getElroySpeed
	call	getTargetBlinky
	ld	hl,redGhostData
	xor	a
	call	ActuallyMove
	ld	hl,redGhostint
	call	chkifneedslow
	ld	de,redGhostData
	call	cpyBack
	ld	hl,currGhostFlash+0
	call	invertGhost
	ld	bc,redGhostSprite
	call	getGhostSprite
	ret

movePinky:
	call	getTargetPinky
	ld	hl,pinkGhostData
	xor	a
	call	ActuallyMove
	ld	hl,pinkGhostint
	call	chkifneedslow
	ld	de,pinkGhostData
	call	cpyBack
	ld	hl,currGhostFlash+1
	call	invertGhost
	ld	bc,pinkGhostSprite
	call	getGhostSprite
	ret
 
moveInky:
	call	getTargetInky
	ld	hl,blueGhostData
	call	chkifleaveInky
	call	ActuallyMove
	ld	hl,blueGhostint
	call	chkifneedslow
	ld	de,blueGhostData
	call	cpyBack
	ld	hl,currGhostFlash+2
	call	invertGhost
	ld	bc,blueGhostSprite
	call	getGhostSprite
	ret
 
moveClyde:
	call	getTargetClyde
	ld	hl,orangeGhostData
	call	chkifleaveClyde
	call	ActuallyMove
	ld	hl,orangeGhostint
	call	chkifneedslow
	ld	de,orangeGhostData
	call	cpyBack
	ld	hl,currGhostFlash+3
	call	invertGhost
	ld	bc,orangeGhostSprite
	call	getGhostSprite
	ret
 
chkifleaveInky:
	ld	a,(currLevel)
	cp	a,2
	ret	nc
	ld	a,(numdotseaten)
	cp	a,30
	ret

chkifleaveClyde:
	ld	a,(currLevel)
	cp	a,3
	ret	nc
	dec	a
	ld	a,(numdotseaten)
	jr	nz,lvl2
	cp	a,60
	ret
lvl2:	cp	a,50
	ret
 
invertGhost:
	ld	a,(hl)
	cp	a,2
	jr	z,+_
	inc	a
	jr	++_
_:
	xor	a
_:
	ld	(hl),a
	ret
 
restoreSpeed:
	ld	de,currGhostData+7
restoreSpeedT:
	ld	a,(hl)
	or	a,a
	ret	z
	ld	(de),a
	ld	(hl),0
	ret
 
chkifneedslow:
	ld	a,(curTileY)
	cp	a,14
	ret	nz
	ld	a,(curTileX)
	cp	a,22
	jr	z,restoreSpeed
	cp	a,5
	jr	z,restoreSpeed
	cp	a,22
	jr	nc,+_
	cp	a,6
	ret	nc   ; left tunnel
_:
	ld	a,(hl)
	or	a,a
	ret	nz
	ld	a,(currGhostData+7)
	ld	(hl),a
	ld	a,2
	ld	(currGhostData+7),a
	ret

ActuallyMove:
	push	af
	ld	de,currGhostData
	ld	bc,10
	ldir
	pop	af
	jr	c,bbbn2

	ld	hl,104+(105*256)
	ld	de,0
	ld	a,(currGhostData)
	ld	e,a
	ld	a,(currGhostData+1)
	ld	d,a
	ld	a,(currGhostData+8)
	cp	a,64
	jr	z,moveout
	call	cphlde
	jr	nz,bbbn2
moveout:
	ld	a,(currGhostData+8)
	dec	e
	ld	(currGhostData),de
	ld	a,3
	ld	(currGhostData+4),a
	ld	a,64
	ld	(currGhostData+8),a
	ld	hl,85+(105*256)
	call	cphlde
	jp	nz,kk
	xor	a
	ld	(currGhostData+8),a
	jp	kk
bbbn2:
	ld	hl,leftopen
	push	hl
	pop	de
	inc	de
	ld	(hl),0
	ld	bc,4
	ldir
 
	ld	a,(currGhostData+4)
	push	af
	ld	de,(currGhostData)
	push	de
	push	de
 	push	de
  	push	de
chkdwn:
   	call	movD
   	jr	nz,chkup
   	inc	a
   	ld	(downopen),a
chkup:
  	pop	de
  	ld	(currGhostData),de
  	call	movU
  	jr	nz,chklft
  	inc	a
  	ld	(upopen),a
chklft:
 	pop	de
 	ld	(currGhostData),de
 	call	movL
 	jr	nz,chkrght
 	inc	a
 	ld	(leftopen),a
chkrght:
	pop	de
	ld	(currGhostData),de
	call	movR
	jr	nz,chkdone
	inc	a
	ld	(rightopen),a
chkdone:
	pop	de
	ld	(currGhostData),de
 
	call	getTileOfGhost
	pop	af
	ld	(currGhostData+4),a
 
	ld	a,(currGhostData+8)  ; if in ghost house; prevent movement up/down
	or	a,a
	jr	z,+_
	ld	a,(leftopen)
	ld	de,(rightopen)
	add	a,e
	cp	a,2
	jr	z,+_
	ld	a,(currGhostData+4)
	or	a,a
	jp	z,right
	jp	left
_:

	ld	a,(currGhostData+4)
	or	a,a
	call	z,storight
	dec	a
	call	z,stoup
	dec	a
	call	z,stoleft
	dec	a
	call	z,stodown

	ld	de,(curTileY)
	ld	hl,11+(12*256)
	call	cphlde
	call	z,stoup
	ld	de,(curTileY)
	ld	hl,11+(15*256)
	call	cphlde
	call	z,stoup
 
	call	getDistances

	ld	a,(currGhostData+6)
	cp	a,EYES_ACTIVE
	jr	nz,+_
	ld	de,(curTileY)
	ld	hl,(targetY)
	dec	l
	call	cphlde
	call	z,reenterHouse
_:
 
	ld	a,(currGhostData+4)
	or	a,a
	jr	z,getLUD
	dec	a
	jr	z,getDRL
	dec	a
	jp	z,getRUD
	dec	a
	jp	z,getURL
 
#include "routines\chkdist.asm"

reenterHouse:
	pop	hl
	xor	a
	ld	(currGhostData+6),a
	dec	a
	ld	(currGhostData+8),a   ; Tells us if we are inside of the house.
	ld	hl,104+(106*256)
	ld	c,2
	call	getRand
	jr	z,+_
	ld	c,0
	dec	h
	dec	h
_:
	ld	a,c
	ld	(currGhostData+4),a
	ld	(currGhostData),hl
	ld	a,(currGhostData+9)
	ld	(currGhostData+7),a
	ret
 
FlashGhosts:
	ex	af,af'
	xor	a \	dec	a
	ld	(needFlash),a
	ex	af,af'
	ret
 
MakeGhostsBad:
	ld	hl,redGhostData+6
	ld	de,10
	ld	b,4
_:
	ld	a,(hl)
	cp	a,EYES_ACTIVE
	jr	z,+_
	ld	(hl),NORMAL_ACTIVE
_:
	add	hl,de
	djnz	--_
	xor	a
	ld	(FrightModeON),a
	ld	(frightTimer),a
	ld	(needFlash),a
Reloadfromtmpspeeds:
	ld	de,tmpspeeds
	ld	hl,redGhostData+7
	ld	b,4
_:
	push	de
	ld	a,(de) ; save the speed so I can restore it after the ghost gets unfrightened
	ld	(hl),a
	ld	de,10
	add	hl,de
	pop	de
	inc	de
	djnz	-_
	ret
 
loadd:
	ld	a,(ScatterModeON)
	or	a,a
	jr	z,+_
	ld	d,20
	ret
_:
	ld	d,6
	ret
 
toggleScatterMode:
	ld	a,(FrightModeON)
	or	a,a
	ret	nz
	ld	a,(scatterActivatedTimes)
	inc	a
	cp	a,10
	jr	c,+_
	xor	a
	jr	++_
_:
	ld	(scatterActivatedTimes),a
	ld	a,(ScatterModeON)
	cpl
_:
	ld	(ScatterModeON),a
	call	reverseAllGhostdirections
	ret
 
cpyBack:
	ld	hl,currGhostData
	ld	bc,10
	ldir
	ret
 
moveGhosts:
	ld	a,(timer)
	inc	a
	ld	(timer),a
	ld	c,a
	ld	a,(redGhostData+7)
	ld	d,a
	call	CdivD
	call	nz,moveBlinky
	ld	a,(timer)
	ld	c,a
	ld	a,(blueGhostData+7)
	ld	d,a
	call	CdivD
	call	nz,moveInky
	ld	a,(timer)
	ld	c,a
	ld	a,(orangeGhostData+7)
	ld	d,a
	call	CdivD
	call	nz,moveClyde
	ld	a,(timer)
	ld	c,a
	ld	a,(pinkGhostData+7)
	ld	d,a
	call	CdivD
	call	nz,movePinky
	ld	a,(timer)
	ld	c,a
	ld	d,10
	call	CdivD
	call	z,invertBigDots
	ld	a,(timer)
	ld	c,a
	ld	d,50
	call	CdivD
	ret	nz
	xor	a
	ld	(pressed2nd),a
	ret
 
inverted:
	.db 0
 
invertBigDots:
	ld	hl,bigdotpiece_sprite
	ld	a,(inverted)
	cpl
	ld	(inverted),a
	or	a,a
	jr	z,+_
	ld	hl,blank_sprite
_:
	ld	(BigBlink_sprite+1),hl
	jp	drawBigDots
 
chkGhostCollisions: 
	call	chkCollisionRed
	call	chkCollisionBlue
	call	chkCollisionOrange
	call	chkCollisionPink
	ret
 
chkGhostTmrs:
	ld	a,(currsec)
	ld	c,a
	call	loadd
	call	CdivD
	call	z,toggleScatterMode
 
	ld	a,(FrightModeON)
	or	a,a
	ret	z
	ld	hl,frightTimer
	ld	c,(hl)
	ld	a,(frighttimerlvl)
	dec	a
	jr	nz,+_
	call	MakeGhostsBad
	ret
_:
	inc	(hl)
	cp	a,c
	call	z,FlashGhosts
	inc	a   ; You have 1 second to avoid the ghost
	cp	a,c
	call	z,MakeGhostsBad
	ret
