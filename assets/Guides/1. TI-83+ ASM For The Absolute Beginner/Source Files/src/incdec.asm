#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    call _homeup
    call _ClrScrnFull

    ; 15 - 1 = a
    ld d,15
    dec d
    
    ; 14 + 3 = b
    ld e,14
    inc e
    inc e
    inc e

    ; a + b from above
    ld a,0
    add a,d
    add a,e

    ld hl,0
    ld l,a

    call _DispHL
    res donePrgm,(iy+doneFlags)
    ret