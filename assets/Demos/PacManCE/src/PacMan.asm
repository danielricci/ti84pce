.nolist
#include "includes\ti84pce.inc"
#include "includes\defines.inc"
#include "includes\macros.inc"
.list

 .org userMem-2
ProgramStart:
	.db tExtTok,tAsm84CeCmp
PROGRAM_HEADER:
	jp	PROGRAM_START
	.db 1									; Signifies a CesiumOS program
	.db 16,16								; Width, Height of sprite
	.db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
	.db 255,255,255,255,255,255,192,192,192,192,255,255,255,255,255,255
	.db 255,255,255,255,192,192,192,192,192,192,192,192,255,255,255,255
	.db 255,255,255,192,192,192,192,192,192,192,192,192,192,255,255,255
	.db 255,255,192,255,255,192,192,192,192,255,255,192,192,192,255,255
	.db 255,255,255,255,255,255,192,192,255,255,255,255,192,192,192,255
	.db 255,255,010,010,255,255,192,192,010,010,255,255,192,192,192,255
	.db 255,192,010,010,255,255,192,192,010,010,255,255,192,192,192,255
	.db 255,192,192,255,255,192,192,192,192,192,255,192,192,192,192,255
	.db 255,192,192,192,192,192,192,192,192,192,192,192,192,192,192,255
	.db 255,192,192,192,192,192,192,192,192,192,192,192,192,192,192,255
	.db 255,192,192,192,192,192,192,192,192,192,192,192,192,192,192,255
	.db 255,192,192,192,192,192,192,192,192,192,192,192,192,192,192,255
	.db 255,192,192,255,192,192,192,255,255,192,192,192,255,192,192,255
	.db 255,192,255,255,255,192,192,255,255,192,192,255,255,255,192,255
	.db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
	.db "Pac-Man Version 1.2",0
PROGRAM_START:
PGRM_BEGIN:
	di
	ld	(saveSP),sp
	call	_RunIndicOff
	call	setup8bppMode
	call	decompressSprites
	call	drawHome
	call	drawHighScores
 
	ld	hl,images_paletteStart+4
	ld	de,$FFFF
	ld	(hl),e
	inc	hl
	ld	(hl),d

	call	FlashInsertCoin
	call	drawHelpScreen
	
	xor	a,a
	sbc	hl,hl
	ld	(addedlife),a
	ld	(score),hl
	inc	a
	ld	(currLevel),a
	inc	a
	ld	(lives),a
	call	restartGame

mainGameLoop:
	call	getKey
	call	chkPauseKey
 
	call	eraseGhosts
	call	erasePacman
	call	movePacMan
	call	moveGhosts
 
	call	chkIfTick
	jr	z,noTimeChange
	call	doSecondStuff
noTimeChange:
	call	chkGhostCollisions
	call	chkFruitCollision
	call	drawPacman
	call	drawGhosts
	call	fullBufCpy
	jp	mainGameLoop

GameOver:
	ld	sp,(saveSP)
	drawSpr255(gameover_sprite, 73, 128)
	call	fullBufCpy
	call	waitfor2ND
	call	getHiLoc
	jp	PGRM_BEGIN
 
LevelEnd:
	ld	sp,(saveSP)
	call	invertScreen
	ld	hl,currLevel
	inc	(hl)
	ld	a,(hl)
	or	a,a
	jr	nz,+_
	inc	a
	ld	(currLevel),a
_:
	call	restartGame
	jp	mainGameLoop
 
FullExit:
	call	_clrscrn
	ld	a,lcdBpp16
	ld	(mpLcdCtrl),a
	call	_homeup
	call	_drawstatusbar
	ld	sp,(saveSP)
	res	OnInterrupt,(iy+onFlags)
	set	graphDraw,(iy+graphFlags)
	ei
	ret
 
drawHome: 
	call	clearScreen
	drawSpr255(pacmanlogo_sprite, 83, 44)
	drawSpr255(pacmanleft1_sprite, 120, 90)
	drawSpr255(ghostred_sprite, 143, 89)
	drawSpr255(eyesleft_sprite, 143, 89)
	drawSpr255(ghostpink_sprite, 162, 89) 
	drawSpr255(eyesleft_sprite, 162, 89)
	drawSpr255(ghostblue_sprite, 181, 89)
	drawSpr255(eyesleft_sprite, 181, 89)
	drawSpr255(ghostorange_sprite, 200, 89)
	drawSpr255(eyesleft_sprite, 200, 89)
 
	jp	loadHighScores
 
#include "routines\appvar.asm"
#include "routines\LCD.asm"
#include "routines\highscore.asm"
#include "routines\map.asm"
#include "routines\text.asm"
#include "routines\other.asm"
#include "routines\keyboard.asm"
#include "routines\initialization.asm"
#include "routines\ghosts.asm"
#include "routines\pacman.asm"
#include "routines\fruit.asm"

MAP_DATA_BEGIN:
#include "data\MapData.asm"
MAP_DATA_END:
TEXT_DATA_BEGIN:
#include "data\TextData.asm"
TEXT_DATA_END:
IMAGE_DATA_BEGIN:
#include "data\ImageData.asm"
IMAGE_DATA_END:
PGRM_END:
.echo "Map Data Size:\t\t",MAP_DATA_END-MAP_DATA_BEGIN
.echo "Text Data Size:\t\t",TEXT_DATA_END-TEXT_DATA_BEGIN
.echo "Image Data Size:\t",IMAGE_DATA_END-IMAGE_DATA_BEGIN
.echo "Image Data Left:\t",(21945*2)-(IMAGE_DATA_END-IMAGE_DATA_BEGIN)
.echo "\nTotal PGRM Size:\t",PGRM_END-PGRM_BEGIN
