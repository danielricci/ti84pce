; This program will print the string `Get a grip` to the display at location 0,0

#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _homeup
    call _ClrScrnFull

    ld hl,Text
    call _PutS
    call _GetKey

    ret

Text: .db "Get a grip",0