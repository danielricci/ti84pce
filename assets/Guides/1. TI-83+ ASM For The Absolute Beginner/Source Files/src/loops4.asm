#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    call _homeup
    call _ClrScrnFull

    ld a,6
    ld b,5

    ld h,2
    ld l,3
    ld d,4
    ld e,5

Loop:
    add a,h
    add a,l
    add a,d
    add a,e
    djnz Loop

    ld hl,0
    ld l,a
    call _DispHL
    res donePrgm,(iy+doneFlags)
    ret
