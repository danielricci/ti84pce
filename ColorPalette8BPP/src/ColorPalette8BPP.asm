#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

color .equ cmdPixelShadow
dimensions .equ color+1

    call _RunIndicOff
    ld a,$FF
    ld (color),a
    ld hl,lcdWidth*lcdHeight
    ld (dimensions),hl
CopyHL1555Palette:
    ld hl,mpLcdPalette
    ld b,0
CopyHL1555PaletteLoop:
    ld d,b
    ld a,b
    and %11000000
    srl d
    rra
    ld e,a
    ld a,%00011111
    and b
    or e
    ld (hl),a
    inc hl
    ld (hl),d
    inc hl
    inc b
    jr nz,CopyHL1555PaletteLoop
    call _boot_ClearVRAM
    ld a,lcdBpp8
    ld (mpLcdCtrl),a
colorize:
    ld a,(color)
    ld hl,vRam
    ld bc,(dimensions)
    call _MemSet
    dec a
    ld (color),a
    call _getKey
    cp kClear
    jr z,exit
    cp a,0
    jr nz,colorize
exit:
    call _ClrScrn
    ld a,lcdBpp16
    ld (mpLcdCtrl),a
    call _DrawStatusBar
    ret