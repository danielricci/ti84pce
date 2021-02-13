#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

Attribute_One .equ 10
Attribute_Two .equ 100
Attribute_Three .equ 1000

MyVariable: 
    .db Attribute_One,Attribute_Two

    call _homeup
    call _ClrScrn

    ld a,(MyVariable)
    ld hl,0
    ld l,a
    call _DispHL

    res donePrgm,(iy+doneFlags)
    ret