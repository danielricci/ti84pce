#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _homeup
    call _ClrScrnFull
    ld a,17
    ld (curRow),a
    ld (curCol),a
    ld hl,Text
    call _PutS
    ret;

Text: .db "A",0