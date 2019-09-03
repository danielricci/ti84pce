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
borderFlags .equ    cmdPixelShadow+11 ;top,left,bottom,right
; --------------------------------------------------
; Entry point of the application
; --------------------------------------------------
init:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrn
    ld a,0
    ld (done),a
    call LCD_CopyHL1555Palette
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
    ld a,159
    ld (pointX),a
    ld a,119
    ld (pointY),a
    call update
    call render
    ret
keyEnterPressed:
    ld a,1
    ld (done),a
    ret
keyUpPressed:
    ld hl,(pointXY)
    ld bc, -lcdWidth
    add hl,bc
    ld (pointXY),hl
    ld (hl),color
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
render:
    call _ClrScrn
    ld hl,(pointXY)
    ld (hl),color
    ret
#include "../../Utils/LCD/src/LCD.asm"
#include "../../Utils/Math/src/Math.asm"