#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _homeup
    call _ClrScrnFull
    
    ld a,(Number_Of_Lives)  ; read from the variable and store it in register A
    add a,5                 ; add 5 to register A
    ld (Number_Of_Lives),a  ; store the contents of register A in the variable

    res donePrgm,(iy+doneFlags)
    ret

Number_Of_Lives:
    .db 5