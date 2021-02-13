#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    call _homeup
    call _ClrScrnFull
    
    ld b,200
    ld a,5

LoopStart:
    add a,1
    djnz LoopStart

    ld hl,0
    ld l,a

    call _DispHL
    res donePrgm,(iy+doneFlags)
    ret