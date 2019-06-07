#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _ClrScrnFull
    call _HomeUp
    ld hl,Text
    call _PutS
    call _GetKey
    ret;

Text: .db "Hello World",0