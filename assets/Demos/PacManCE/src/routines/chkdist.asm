getLUD:
	ld	a,(currGhostData+8)
	or	a,a
	jr	nz,left
	ld	hl,(leftdist)
	ld	de,(updist)
	call	cphlde
	jr	c,leftLESSup
			; So we either want to go up	or	a,down
	ld	hl,(downdist)
	ld	de,(updist)
	call	cphlde
	jr	c,down
	jr	up
leftLESSup:		; So we either want to go left	or	a,down
	ld	hl,(downdist)
	ld	de,(leftdist)
	call	cphlde
	jr	c,down
	jr	left

getDRL:
	ld	hl,(downdist)
	ld	de,(rightdist)
	call	cphlde
	jr	c,downLESSright
			; So we either want to go right	or	a,left
	ld	hl,(leftdist)
	ld	de,(rightdist)
	call	cphlde
	jr	c,left
	jr	right
downLESSright:		; So we either want to go down	or	a,left
	ld	hl,(leftdist)
	ld	de,(downdist)
	call	cphlde
	jr	c,left
	jr	down
 
down:
	ld	a,1
	ld	(currGhostData+4),a
	jp	kk
right:
	ld	a,2
	ld	(currGhostData+4),a
	jp	kk
left:
	xor	a
	ld	(currGhostData+4),a
	jp	kk
up:
	ld	a,3
	ld	(currGhostData+4),a
	jp	kk
	
getRUD:
	ld	a,(currGhostData+8)
	or	a,a
	jr	nz,right
	ld	hl,(rightdist)
	ld	de,(updist)
	call	cphlde
	jr	c,rightLESSup
			; So we either want to go up	or	a,down
	ld	hl,(downdist)
	ld	de,(updist)
	call	cphlde
	jr	c,down
	jr	up
rightLESSup:		; So we either want to go right	or	a,down
	ld	hl,(downdist)
	ld	de,(rightdist)
	call	cphlde
	jr	c,down
	jr	right

getURL:
	ld	hl,(updist)
	ld	de,(rightdist)
	call	cphlde
	jr	c,upLESSright
			; So we either want to go right	or	a,left
	ld	hl,(leftdist)
	ld	de,(rightdist)
	call	cphlde
	jr	c,left
	jr	right
upLESSright:		; So we either want to go up	or	a,left
	ld	hl,(leftdist)
	ld	de,(updist)
	call	cphlde
	jr	c,left
	jr	up