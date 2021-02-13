#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    call _homeup
    call _ClrScrnFull

    ld hl,MyText
    call _PutS

    res donePrgm,(iy+doneFlags)
    ret;

MyText:
    .db "This is an example of some text",0