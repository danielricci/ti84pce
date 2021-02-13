#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _ClrScrnFull
    ld b,127

KeyLoop:
    call _getKey

    ;Handle key up
    cp kUp
    jr Z,Increase

    ;Handle key down
    cp kDown
    jr Z,Decrease

    ;Handle key clear
    cp kClear
    ret Z

    ;Handle any other input
    jr KeyLoop

Increase:
    ld a,b
    cp 255
    jr Z,KeyLoop
    inc b
    jr Display

Decrease:
    ld a,b
    cp 0
    jr Z,KeyLoop
    dec b
    jr Display

Display:
    ld a,0
    ld (curRow),a
    ld a,0
    ld (curCol),a
    ld hl,0
    ld l,b
    call _DispHL
    jr KeyLoop
    ret