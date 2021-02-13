#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _homeup
    call _ClrScrnFull

    ld a,3
    ld (curRow),a
    ld a,1
    ld (curCol),a

    ld hl,Text
    call _PutS

    ret

Text: .db "Ti-83+ Z80 ASM",0