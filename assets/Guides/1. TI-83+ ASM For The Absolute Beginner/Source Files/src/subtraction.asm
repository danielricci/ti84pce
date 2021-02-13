#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _homeup
    call _ClrScrnFull
    
    ld a,50
    sub a,25
    ld hl,0
    ld l,a

    call _DispHL
    call _GetKey
    call _ClrScrnFull
    res donePrgm,(iy+doneFlags)
    ret
