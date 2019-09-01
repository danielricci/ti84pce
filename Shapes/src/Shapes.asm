#include "ti84pce.inc"
.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

; --------------------------------------------------
; Equates
; --------------------------------------------------
color .equ          $E0
done .equ           cmdPixelShadow
pointX .equ         cmdPixelShadow+1
pointY .equ         cmdPixelShadow+4
pointXY .equ        cmdPixelShadow+7
; --------------------------------------------------
; Entry point of the application
; --------------------------------------------------
init:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrn
    ld a,0
    ld (done),a
    ld a,159
    ld (pointX),a
    ld a,119
    ld (pointY),a
    call copyHL1555Palette
    jr mainLoop
; --------------------------------------------------
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
    ret
keyOnePressed: ;draws a point in the middle of display
    call clearScreen
    
    ld a,24
    ld bc,(pointY)
    ld de,lcdWidth
    call Math_Multiply_BC_DE

    ld bc,(pointX)
    add hl,bc
    ld bc,vRam
    add hl,bc

    ld (pointXY),hl
    ld (hl),color

    ret
keyEnterPressed:
    ld a,1
    ld (done),a
    ret
keyUpPressed:
    ;call clearScreen
    ;ld hl,(point)
    ;ld bc, -lcdWidth
    ;add hl,bc
    ;ld (point),hl
    ;ld (hl),color
    ret
keyLeftPressed:
    ; Get the current position of the particle
    ;or a,a
    ;ld hl,(point)
    ;ld bc,vRam
    ;sbc hl,bc
    ; Bounds check for valid position
    ;ex de,hl
    ;ld bc,lcdWidth
    ;cp a,0
    ;ld hl,(point)
    ;dec hl
    ;ld (point),hl
    ;call clearScreen
    ;ld (hl),color
    ret
keyDownPressed:
    ;call clearScreen
    ;ld hl,(point)
    ;ld bc,lcdWidth
    ;add hl,bc
    ;ld (point),hl
    ;ld (hl),color
    ret
keyRightPressed:
    call clearScreen
    ;ld hl,(point)
    ;inc hl
    ;ld (point),hl
    ;ld (hl),color
    ret
updatePoint:
    ;ld a,(pointY)
    ;ld hl,a
    ret
#include "../../Math/src/Math.asm"