#include "ti84pce.inc"

#define BLACK_COLOR 0
#define vBuf1 vRAM
#define vBuf2 vBuf1+(320*240)

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp
    call _ClrScrnFull
    call _HomeUp
    call _RunIndicOff

    ;call colorScreen
	;call colorGreen
	call fillScreen
    call _GetKey
	;call colorBlue
    ;call _GetKey
	;call colorRed
    ;call _GetKey
    call _ClrScrn
	call _DrawStatusBar
    ret

; Fill VRAM with the 16-bit color in de
fillScreen:
	ld de,$F800
	ld hl,vRam
	ld (hl),de
	ld de,vRam+2
	ld bc,lcdWidth*lcdHeight*2-2
	ldir
	ret

colorBlue:
	ld hl,vRam
	ld (hl),%11111000
	inc hl
	ld (hl),%00000000
	ret

colorRed:
	ld hl,vRam
	ld (hl),%00000111
	inc hl
	ld (hl),%11100000
	ret

colorGreen:
	ld hl,vRam
	ld (hl),%11100000
	inc hl
	ld (hl),%00000111
	ret

colorScreen:
	ld hl,vRam
	ld (hl),$41
	ld de,vRam+1
	ld bc,(vRamEnd-vRam)-2
	ldir
	ret

clearScreen:
	ld a,$00
	ld bc,320*240*2
	ld hl,vRam
	call _MemClear
    ret