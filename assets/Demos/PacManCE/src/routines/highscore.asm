saveNewScores:
	push	af
_:
	ld	hl,pacManAppVar
	call	_Mov9ToOP1
	call	_ChkFindSym
	call	_chkinram
	jr	z,inRAM
	call	_Arc_Unarc
	jr	-_
inRAM:
	ld	ix,header 
	ld	hl,(progPtr) 
	call	fdetect
	pop	hl
	push	de
	ld	l,15
	mlt	hl
	add	hl,de
	ex	de,hl		; Got insertion address
	ld	hl,15
	call	_InsertMem	; de is intact
	ld	hl,ScoreStrings
	ld	bc,11
	ldir
	ex	de,hl
	ld	de,(score)
	ld	(hl),de
	inc	hl
	inc	hl
	inc	hl
	ld	a,(currlevel)
	ld	(hl),a
	pop	hl
	ld	de,75
	add	hl,de
	ld	de,15
	call	_DelMem		; free the memory
	ld	hl,pacManAppVar
	call	_Mov9ToOP1
	call	_ChkFindSym
	jp	_Arc_Unarc

erase200:
	ld	bc,(s200loc)
	jr	sdf
erase400:
	ld	bc,(s400loc)
	jr	sdf
erase800:
	ld	bc,(s800loc)
	jr	sdf
erase1600:
	ld	bc,(s1600loc)
sdf:
	push	hl
	ld	h,15
	ld	l,8
	call	drawClearingRect
	pop	hl
	ret

drawHighScores:
	ld	hl,82+(33*256)
	ld	b,5
_:
	ld	a,5
	sub	a,b
	ld	(CurHI+1),a
	push	bc
	push	hl
	ld	a,'6'
	sub	a,b
	push	hl
	pop	bc
	push	de
 	call	drawChar
 	ld	a,':'
 	call	drawChar
 	ld	a,' '
 	call	drawChar
	pop	de
 	ex	de,hl
	call	drawString
	push	hl
 	push	de
  	push	bc
   	ld	de,(hl)
   	ld	hl,HiScoreTbl
CurHI:
   	ld	b,0
   	ld	c,3
    	mlt	bc
   	add	hl,bc
  	pop	bc
  	ld	(hl),de
   	ex	de,hl
  	ld	b,32+60-3
  	call	DispHL
 	pop	de
	pop	hl
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	b,32+60-3+30+1
	call	DispA
 	ex	de,hl
	pop	hl
	ld	a,l
	add	a,7
	ld	l,a
	pop	bc
	djnz	-_
	ret
 
;If A < N, then C flag is set.
;If A >= N, then C flag is reset.
;	returns A = place to insert new NewHighString score.
getHiLoc:
	ld	de,(score)
	ld	hl,HiScoreTbl
	ld	b,5
_:
	push	hl
	ld	hl,(hl)
	call	cphlde
	pop	hl
	jr	c,foundLoc
	inc	hl
	inc	hl
	inc	hl
	djnz	-_
foundLoc:
	ld	a,5
	sub	a,b		; get location
	cp	a,5		; this means we didn't get a NewHighString score. :(
	ret	z
	push	af
	call	drawHome
	printf(NewHighString, 108, 120)
	ld	bc,((116/2)*256)+(150/2)
	pop	af
	push	af
	inc	a
	call	DispA1place
	ld	a,':'
	call	drawChar
	ld	de,140
	ld	b,10
_:
	push	de
	push	bc
 	ld	a,160
 	ld	b,7
 	call	drawHLine
	pop	bc
	pop	de
	ld	hl,8
	add	hl,de
	ex	de,hl
	djnz	-_
	call	getNewString
	pop	af
	jp	saveNewScores