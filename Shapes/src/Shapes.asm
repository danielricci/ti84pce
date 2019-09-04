#include "ti84pce.inc"
.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

; --------------------------------------------------
; Equates
; --------------------------------------------------
color           .equ        $E0
initX           .equ        159
initY           .equ        119
done            .equ        cmdPixelShadow
pointX          .equ        cmdPixelShadow+1
pointY          .equ        cmdPixelShadow+4
pointXYPrev     .equ        cmdPixelShadow+7
pointXY         .equ        cmdPixelShadow+10

; --------------------------------------------------
; Entry point of the application
; --------------------------------------------------
init:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrn
    call LCD_CopyHL1555Palette
    ld a,0
    jr mainLoop

; --------------------------------------------------
; Clean up code before the application terminates
; --------------------------------------------------
exit:
    call _ClrScrn
    call LCD_ResetPalette
    call _DrawStatusBar
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
keyOnePressed:
    ld bc,initX
    ld (pointX),bc
    ld bc,initY
    ld (pointY),bc
    call update
    call render
    ret
keyEnterPressed:
    ld a,1
    ld (done),a
    ret
keyUpPressed:
    ld hl,(pointY)
    ld bc,0
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    dec hl
    ld (pointY),hl
    call update
    call render
    ret
keyDownPressed:
    ld hl,(pointY)
    ld bc,239
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    inc hl
    ld (pointY),hl
    call update
    call render
    ret
keyLeftPressed:
    ld hl,(pointX)
    ld bc,0
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    dec hl
    ld (pointX),hl
    call update
    call render
    ret
keyRightPressed:
    ld hl,(pointX)
    ld bc,319
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    inc hl
    ld (pointX),hl
    call update
    call render
    ret

; --------------------------------------------------
; Updates the (x,y) location data
; --------------------------------------------------
update:
    ld bc,(pointY)
    ld de,lcdWidth
    ld a,24
    call Math_Multiply_BC_DE

    ld bc,(pointX)
    add hl,bc
    ld bc,vRam
    add hl,bc

    ld (pointXY),hl
    ret

; --------------------------------------------------
; Renders the (x,y) location data
; --------------------------------------------------
render:
    call _ClrScrn
    ld hl,(pointXY)
    ld (hl),color
    ret

; --------------------------------------------------
; Includes
; --------------------------------------------------
#include "../../Utils/LCD/src/LCD.asm"
#include "../../Utils/Math/src/Math.asm"
