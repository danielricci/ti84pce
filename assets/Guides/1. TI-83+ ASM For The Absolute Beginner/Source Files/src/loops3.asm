#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp
    call _homeup
    call _ClrScrnFull

    ld a,0
    ld b,10
    ld h,5

Loop
    add a,h
    djnz Loop

    ld hl,0
    ld l,a

    call _DispHL
    res donePrgm,(iy+doneFlags)
    ret;
