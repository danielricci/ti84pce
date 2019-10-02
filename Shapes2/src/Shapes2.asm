#include "includes/ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

dimensions .equ 3 ; 3x3 per body part
color .equ $E0

done .equ cmdPixelShadow
snake.length .equ done+1
snake.body .equ snake.length+3

init:
    ; Board setup
    call _HomeUp
    call _RunIndicOff
    call _ClrScrnFull
    call LCD_CopyHL1555Palette

    ; Length initialization
    ld bc,6
    ld hl,snake.length
    ld (hl),bc

    ; Snake body initialization
    ld de,159
    ld b,c
    ld hl,snake.body
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
    call _ClrScrnFull
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
    ; Clear the screen
    ld a,$FF
    ld bc,lcdWidth*lcdHeight
    call LCD_ClearLCDHalf

    ; The initial address starts at the tail and works
    ; its way up to the head of the snake
    ld ix,snake.body
    ld bc,(snake.length)
    
render_loop_length:
    
    ; Push the length of the snake, note that this will need to be re-pushed at
    ; the end of the loop
    push bc
    
    ; Calculate y-position
    ld bc,(ix)
    inc ix
    inc ix
    inc ix
    ld de,lcdWidth
    ld a,24
    call Math_Multiply_BC_DE

    ; Calculate x-position
    ld bc,(ix)
    inc ix
    inc ix
    inc ix
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

    ; Pop back the length of the snake
    pop bc
    dec bc
    ld a,b
    or c
    jr nz,render_loop_length
    ret
; --------------------------------------------------

; --------------------------------------------------
; Includes
; --------------------------------------------------
#include "../../Utils/Math/src/Math.asm"
#include "../../Utils/LCD/src/LCD.asm"
; --------------------------------------------------