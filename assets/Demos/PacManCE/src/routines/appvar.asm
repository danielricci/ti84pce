loadHighScores:
	ld	ix,header 
	ld	hl,(progPtr) 
	call	fdetect
	ret	z
	call	reloadHighScores
	jr	loadHighScores

reloadHighScores:
	ld	hl,100			; Make It Big Enough -- So that way it can handle anything!
	call	_enoughmem
	jp	c,errorMem		; Ha, Ha! You Had A Memory Error!
	ld	hl,pacManAppVar
	call	_Mov9ToOP1
	ld	hl,80			; And... Something Tiny To Get Started
	call	_CreateAppVar
	inc	de
	inc	de
	ld	hl,header
	ld	bc,header_end-header
	ldir				; Copy in the header for the appvar
	ld	hl,mateoScore
	ld	bc,mateoScore_end-mateoScore
	ldir
	ld	hl,emptyScore
	ld	b,4
_:
	push	hl
	push	bc
	ld	bc,emptyScore_end-emptyScore
	ldir
	pop	bc
	pop	hl
	djnz	-_
	ret

errorMem:
 popcall();
	jp	FullExit
 
SetDEUtoA equ 021D68h

;--------------------------------------------
; fdetect
; detects appvars, prot progs, and
; progs given a 0-terminated string
; pointed to by ix.
;--------------------------------------------
; INPUTS:
; hl->place to start searching
; ix->string to find
;
; OUTPUTS:
; hl->place stopped searching
; de->file data after string

; bc=file size after string
; z flag	set	if found, nz if not found
;--------------------------------------------
fdetect:
	ld	de,(ptemp)
	or	a,a 
	sbc	hl,de 
	add	hl,de
	ld	a,(hl)
	jr	nz,fcontinue
	inc	a
	ret
fcontinue:
	push	hl
	cp	a,appvarobj
	jr	z,fgoodtype
	cp	a,protprogobj
	jr	z,fgoodtype
	cp	a,progobj
	jr	nz,fskip
fgoodtype:
	dec	hl
	dec	hl
	dec	hl
	ld	e, (hl)
	dec	hl
	ld	d,(hl)
	dec	hl
	ld	a,(hl)
	call	SetDEUtoA
	push	de
	pop	hl
	cp	a,$D0
	jr	nc,finRAM
	push	ix
	push	de
	push	hl
	pop	ix
	ld	a,10
	add	a,(ix+9)
	ld	de,0
	ld	e,a
	add	hl,de
 	ex	(sp),hl
	add	hl,de
	pop	de
	ex	de,hl
	pop	ix
finRAM:
	inc	de
	inc	de
	ld	bc,0
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl	; hl -> data
	push	bc	; bc = size
	push	ix
	pop	bc
fchkstr:
	ld	a,(bc)
	or	a,a
	jr	z,ffound
	cp	a,(hl)
	inc	bc
	inc	de
	inc	hl
	jr	z,fchkstr
	pop	bc
fskip:
	pop	hl
	call	fbypassname
	jr	fdetect
ffound:
	push	bc
	pop	hl
	push	ix
	pop	bc
	or	a,a
	sbc	hl,bc
	push	hl
	pop	bc
	pop	hl	; size
	or	a,a
	sbc	hl,bc
	push	hl
	pop	bc
	pop	hl		; current search location
	push	bc
	call	fbypassname
	pop	bc
	xor	a
	inc	de
	ret
fbypassname:
	ld	bc,-6
	add	hl,bc
	ld	b,(hl)
	dec	hl
fbypassnameloop:
	dec	hl
	djnz	fbypassnameloop
	ret

header:
	.db $EF,$7B,$C9,$CB,0
header_end: