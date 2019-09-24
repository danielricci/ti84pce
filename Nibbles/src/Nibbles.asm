#include "includes/ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

dimensions .equ 3
color .equ $E0

done .equ cmdPixelShadow
length .equ done+1
snake .equ length+3
snake.tail .equ snake
snake.head .equ snake.tail+24

init:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrnFull
    call LCD_CopyHL1555Palette

    ; Set the initial length of the snake
    ld bc,5
    ld hl,length
    ld (hl),bc

    ; Initialize the coordinates of each part of the snake
    ld de,159
    ld b,5
    ld hl,snake
init_snake:
    ld (hl),119 ; y-coordinate
    inc hl
    inc hl
    inc hl
    ld (hl),de ; x-coordinate
    inc de
    inc hl
    inc hl
    inc hl
    djnz init_snake
    jr main_loop
exit:
    call _ClrScrn
    call LCD_ResetPalette
    call _DrawStatusBar
    ret
main_loop:
    ld a,(done)
    cp 1
    jr Z,exit
    call process_input
    call render
    jr main_loop

; --------------------------------------------------
; User input phase
; --------------------------------------------------
process_input:
    call _getKey
    cp kUp
    call Z,key_up
    cp kLeft
    call Z,key_left
    cp kDown
    call Z,key_down
    cp kRight
    call Z,key_right
    cp kEnter
    call Z,key_enter
    ret
key_up:
key_left:
key_down:
key_right:
    ret
key_enter:
    ld a,1
    ld (done),a
    ret
; --------------------------------------------------

; --------------------------------------------------
; Game rendering phase
; --------------------------------------------------
render:
    call _ClrScrnFull
    ; ld a,$FF
    ; ld bc,lcdWidth*lcdHeight
    ; call LCD_ClearLCDHalf
    
    ld hl,snake
    ; Calculate y-position
    ld bc,(hl)
    ld de,lcdWidth
    ld a,24
    push hl
    call Math_Multiply_BC_DE
    ; Calculate x-position
    pop ix
    inc ix
    inc ix
    inc ix
    push ix
    ld bc,(ix)
    add hl,bc
    ld bc,vRam
    add hl,bc
    
    ld a,dimensions
    ld b,a
render_loop_height:
    push bc
    ld a,dimensions
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

; --------------------------------------------------
; Includes
; --------------------------------------------------]
#include "../../Utils/Math/src/Math.asm"
#include "../../Utils/LCD/src/LCD.asm"
; --------------------------------------------------