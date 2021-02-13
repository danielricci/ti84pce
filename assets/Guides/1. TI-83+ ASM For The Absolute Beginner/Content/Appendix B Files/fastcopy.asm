fastcpy:

	ld hl, plotsscreen	
	di
	ld c,$10
	ld a,$80
setrow:
	in b,(c)
	jp m,setrow
	out ($10),a
	ld de,11
	ld a,$20
col:
	in b,(c)
	jp m,col
	out ($10),a
	push af
	inc c
	ld b,64
row:

rowwait:
	in a,($10)
	jp m,rowwait
	outi
	add hl,de
	jp nz, rowwait
	pop af
	dec h
	dec h
	dec h
	dec c
	inc hl
	inc a
	cp $2c
	jp nz,col
	ei
	ret