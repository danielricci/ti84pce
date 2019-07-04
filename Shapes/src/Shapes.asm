.nolist
#include "ti84pce.inc"
.list
.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

done equ cmdpixelshadow

main:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrn
    jr init
clean:
    call _ClrScrn
    call _DrawStatusBar
    ret
init:
    ld a,0
    ld (done),a
main_loop:
    ld a,(done)
    cp 1
    jr Z,clean
    call processInput
    call update
    call render
    jr main_loop
processInput:
    call _getKey
    cp kUp
    call Z,keyUpPressed
    cp kLeft
    call Z,keyLeftPressed
    cp kDown
    call Z,keyDownPressed
    cp kRight
    call Z,keyRightPressed
    cp kEnter
    call Z,keyEnterPressed
    ret
keyUpPressed:
keyLeftPressed:
keyDownPressed:
keyRightPressed:
keyEnterPressed:
    ld a,1
    ld (done),a
    ret
update:
    ret
render:
    ret