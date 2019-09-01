;#define DEBUG
#ifdef DEBUG
#include "ti84pce.inc"
.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp
#endif
Math_Divide_C_D:
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
Math_Multiply_BC_DE:
#ifdef DEBUG
   ld de,500
   ld bc,500
   ld a,24
#endif
    ld hl,0
mul_loop:
    srl b
    rr c
    jr nc,no_add
    add hl,de
no_add:
    ex de,hl
    add hl,hl
    ex de,hl
    dec a
    jr nz,mul_loop
    ret