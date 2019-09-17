#include "includes/ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

done .equ cmdPixelShadow

init:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrnFull
    call LCD_CopyHL1555Palette
    ld a,0
    jr main_loop
exit:
    call _ClrScrn
    call LCD_ResetPalette
    call _DrawStatusBar
    ret
main_loop:
    ld a,(done)
    cp 1
    jr Z,exit
    call process_input
    jr main_loop
process_input:
    call _getKey
    cp kUp
    call Z,key_up
    cp kLeft
    call Z,key_left
    cp kDown
    call Z,key_down
    cp kRight
    call Z,key_right
    cp kEnter
    call Z,key_enter
    ret
key_up:
key_left:
key_down:
key_right:
key_enter:
    ld a,1
    ld (done),a
    ret

#include "../../Utils/LCD/src/LCD.asm"