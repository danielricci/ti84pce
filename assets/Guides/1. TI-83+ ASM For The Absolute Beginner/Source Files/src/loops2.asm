#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    
    call _homeup
    call _ClrScrnFull
    
    ld b,100
    ld a,250
LoopStart:
    sub a,2
    djnz LoopStart

    ld hl,0
    ld l,a
    call _DispHL
    
    res donePrgm,(iy+doneFlags)
    ret
