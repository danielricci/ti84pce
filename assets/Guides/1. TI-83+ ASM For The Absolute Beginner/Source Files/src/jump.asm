#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    call _homeup
    call _ClrScrnFull
    ld a,5
    add a,2
    jr LoadIntoHL
    ret
    
LoadIntoHL:
    ld hl,0
    ld l,a
    call _DispHL
    call _GetKey
    res donePrgm,(iy+doneFlags)
    ret
