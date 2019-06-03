#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp
    call _ClrScrnFull
    call _HomeUp
    call _RunIndicOff

mainLoop:
    call _getKey
    cp kUp
    jr Z,colorGreen
    cp kLeft
    jr Z,colorRed
    cp kRight
    jr Z,colorBlue
    cp kDown
    jr Z,colorBlack
    jr done

colorRed:
    ld de,%1111100000000000
    jr fillScreen

colorGreen:
    ld de,%0000011111100000
    jr fillScreen

colorBlue:
    ld de,%0000000000011111
    jr fillScreen

colorBlack:
    ld de,%0000000000000000
    jr fillScreen

fillScreen:
    ld hl,vRam
    ld (hl),de
    ld de,vRam+2
    ld bc,lcdWidth*lcdHeight*2-2
    ldir
    jr mainLoop

done:
    call _ClrScrn
    call _DrawStatusBar
    ret