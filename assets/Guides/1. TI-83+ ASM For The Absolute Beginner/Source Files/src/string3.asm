; This program will display the specified text to screen starting at coordinate 1,1

#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp
    call _homeup
    call _ClrScrnFull
    
    ld a,1
    ld (curRow),a 
    ld a,1
    ld (curCol),a

    ld hl,Text

    call _PutS
    call _GetKey

    res donePrgm,(iy+doneFlags)
    ret

Text: 
    .db "This is fun!!",0