#include "includes/ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp
    call _ClrScrnFull
    call _HomeUp
    call _RunIndicOff
done:
    call _ClrScrn
    call _DrawStatusBar
    ret

#include "Graphics.asm"