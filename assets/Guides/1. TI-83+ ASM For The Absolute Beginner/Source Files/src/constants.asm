#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

Constant .equ 100
    call _ClrScrn
    ld a,Constant
    ld hl,0
    ld l,a
    call _DispHL
    res donePrgm,(iy+doneFlags)
    ret
