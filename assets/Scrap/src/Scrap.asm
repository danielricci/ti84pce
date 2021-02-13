#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

length .equ cmdPixelShadow
snake .equ length+3
snake.tail .equ snake
snake.head .equ snake.tail+24

    call _HomeUp
    call _RunIndicOff
    call _ClrScrnFull
    
    ; Set the initial length of the snake
    ld bc,5
    ld hl,length
    ld (hl),bc

    ; Initialize the coordinates of each part of the snake
    ld de,159
    ld b,5
    ld hl,snake
init_snake:
    ld (hl),de ; x-coordinate
    inc de
    inc hl
    inc hl
    inc hl
    ld (hl),119 ; y-coordinate
    inc hl
    inc hl
    inc hl
    djnz init_snake
    ret