.option BM_SHD=2
.option bm_min_w=96

#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

    call _ClrScrnFull
    call _RunIndicOff
    ld hl,image
    ld de,plotsscreen
    ld bc,768
    ldir

    call _GrBufCpy
    call _getKey
    call _ClrScrnFull
    call _DispDone

    ret

image:
#include "ready.bmp"