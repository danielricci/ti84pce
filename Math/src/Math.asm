#include "ti84pce.inc"
.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp
    ld c,4
    ld d,2
C_Div_D_8bit:
    ld b,8
    xor a
        sla c
        rla
        cp d
        jr c,$+4
            inc c
            sub d
    djnz $-8
    ret