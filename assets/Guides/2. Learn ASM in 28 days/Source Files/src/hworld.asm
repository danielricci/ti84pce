.nolist
#include "ti84pce.inc"
.list

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _ClrScrnFull
    call _GetKey
    ret
.end
.end
message: .db "Hello World",0