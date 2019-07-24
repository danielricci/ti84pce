.nolist
#include "ti84pce.inc"
.list
.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

; --------------------------------------------------
; Equates
; --------------------------------------------------
done .equ cmdPixelShadow
point .equ done+1
color .equ $E0
; --------------------------------------------------
; Entry point of the application
; --------------------------------------------------
init:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrn
    ld a,0
    ld (done),a
    ld hl,vRam+(lcdWidth/2)+(lcdWidth*(lcdHeight/2))
    ld (point),hl
    call copyHL1555Palette
    jr mainLoop
; -----------------------------
; Clean up code before the application terminates
; --------------------------------------------------
exit:
    call _ClrScrn
    ld a,lcdBpp16
    ld (mpLcdCtrl),a
    call _DrawStatusBar
    ret
; --------------------------------------------------
; Sets the color palette to an 8BPP format
; --------------------------------------------------
copyHL1555Palette:
    ld hl,mpLcdPalette
    ld b,0
copyHL1555PaletteLoop:
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
    ret
; --------------------------------------------------
; Clears the screen by applying the color `white` to every pixel of the lcd
; --------------------------------------------------
clearScreen:
    call _boot_ClearVRAM
    ret
; --------------------------------------------------
; Main game loop
; --------------------------------------------------
mainLoop:
    ld a,(done)
    cp 1
    jr Z,exit
    call processInput
    call update
    call render
    jr mainLoop
; --------------------------------------------------
; Processes the user input key commands
; 
; Note: Subsequent labels underneath handle the specified user input
; --------------------------------------------------
processInput:
    call _getKey
    cp k1
    call Z,keyOnePressed
    cp k2
    call Z,keyTwoPressed
    cp k3
    call Z,keyThreePressed
    cp k4
    call Z,keyFourPressed
    cp kUp
    call Z,keyUpPressed
    cp kLeft
    call Z,keyLeftPressed
    cp kDown
    call Z,keyDownPressed
    cp kRight
    call Z,keyRightPressed
    cp kEnter
    call Z,keyEnterPressed
    cp kClear
    call Z,keyClearPressed
    ret
keyOnePressed: ;point
    call clearScreen
    ld hl,(point)
    ld (hl),color
    ret
keyTwoPressed:
keyThreePressed:
keyFourPressed:
keyEnterPressed:
keyClearPressed:
    ld a,1
    ld (done),a
    ret
keyUpPressed:
    call clearScreen
    ld hl,(point)
    ld bc, -lcdWidth
    add hl,bc
    ld (point),hl
    ld (hl),color
    ret
keyLeftPressed:
    call clearScreen
    ld hl,(point)
    dec hl
    ld (point),hl
    ld (hl),color
    ret
keyDownPressed:
    call clearScreen
    ld hl,(point)
    ld bc,lcdWidth
    add hl,bc
    ld (point),hl
    ld (hl),color
    ret
keyRightPressed:
    call clearScreen
    ld hl,(point)
    inc hl
    ld (point),hl
    ld (hl),color
    ret
; --------------------------------------------------
; Performs an update of the application by changing subsequent values based on
; past user input
; --------------------------------------------------
update:
    ret
; --------------------------------------------------
; Renders the content
; --------------------------------------------------
render:
    ret