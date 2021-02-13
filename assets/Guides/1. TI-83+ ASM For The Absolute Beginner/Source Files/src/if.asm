#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    call _homeup
    call _ClrScrnFull

    ld a,1
    cp 1
    jr z,DisplayNumber1
    res donePrgm,(iy+doneFlags)
    ret

DisplayNumber1:
    ld hl,0
    ld l,a
    call _DispHL
    call _GetKey
    ret