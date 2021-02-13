#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _ClrScrnFull
    ld a,3
    ld (curRow),a
    ld a,2
    ld (curCol),a

    ld hl,MyText

    call _PutS
    call _getKey
    call _ClrScrnFull
    res donePrgm,(iy+doneFlags)
    ret

MyText: .db "Hello World",0