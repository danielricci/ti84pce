#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

; --------------------------------------------------
; Constants
; --------------------------------------------------
color       .equ        $E0

; --------------------------------------------------
; Memory Managed Equates
; --------------------------------------------------
done .equ cmdPixelShadow

rectangle .equ done+1
rectangle.x .equ rectangle
rectangle.y .equ rectangle+3
rectangle.w .equ rectangle+6
rectangle.h .equ rectangle+9


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
    cp k2
    call Z,keyTwoPressed
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
    ld hl,159
    ld (rectangle.x),hl
    ld hl,119
    ld (rectangle.y),hl
    ld hl,1
    ld (rectangle.w),hl
    ld (rectangle.h),hl
    call render
    ret
keyTwoPressed:
    ld hl,159
    ld (rectangle.x),hl
    ld hl,119
    ld (rectangle.y),hl
    ld hl,3
    ld (rectangle.w),hl
    ld hl,3
    ld (rectangle.h),hl
    call render
    ret
keyEnterPressed:
    ld a,1
    ld (done),a
    ret
keyUpPressed:
    ld hl,(rectangle.y)
    ld bc,0
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    dec hl
    ld (rectangle.y),hl
    call render
    ret
keyDownPressed:
    ld hl,(rectangle.y)
    ld bc,0
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    inc hl
    ld (rectangle.y),hl
    call render
    ret
keyLeftPressed:
    ld hl,(rectangle.x)
    ld bc,0
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    dec hl
    ld (rectangle.x),hl
    call render
    ret
keyRightPressed:
    ld hl,(rectangle.x)
    ld bc,319
    or a
    sbc hl,bc
    add hl,bc
    ret Z

    inc hl
    ld (rectangle.x),hl
    call render
    ret

; --------------------------------------------------
; Render to the LCD
; --------------------------------------------------
render:
    ;call _ClrScrnFull
    ld a,$FF
    ld bc,lcdWidth*lcdHeight
    call LCD_ClearLCDHalf

    ; Calculate (x,y)
    ld bc,(rectangle.y)
    ld de,lcdWidth
    ld a,24
    call Math_Multiply_BC_DE
    ld bc,(rectangle.x)
    add hl,bc
    ld bc,vRam
    add hl,bc
    
    ld a,(rectangle.h)
    ld b,a
render_loop_height:
    push bc
    ld a,(rectangle.w)
    ld b,a
render_pixel:
    ; Draw pixel and increment print position
    ld (hl),color
    inc hl
    djnz render_pixel

    ; Carriage return (CR)
    ld de,0
    ld e,a
    or a
    sbc hl,de

    ; Line feed (LF)
    ld de,lcdWidth
    add hl,de

    ; Draw a new line
    pop bc
    djnz render_loop_height
    ret

; --------------------------------------------------
; Includes
; --------------------------------------------------
#include "../../Utils/LCD/src/LCD.asm"
#include "../../Utils/Math/src/Math.asm"
