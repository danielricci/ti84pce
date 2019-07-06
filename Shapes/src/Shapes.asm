.nolist
#include "ti84pce.inc"
.list
.assume ADL=1
.org userMem-2
.db tExtTok, tAsm84CeCmp

; --------------------------------------------------
; Equates
; --------------------------------------------------
done equ cmdPixelShadow

; --------------------------------------------------
; Entry point of the application
; --------------------------------------------------
main:
    call _HomeUp
    call _RunIndicOff
    call _ClrScrn
    jr ctor
; --------------------------------------------------
; Clean up code before the application terminates
; --------------------------------------------------
clean:
    call _ClrScrn
    call _DrawStatusBar
    ret
; --------------------------------------------------
; Constructs this application by loading the proper default values
; --------------------------------------------------
ctor:
    ld a,0
    ld (done),a
; --------------------------------------------------
; Clears the screen by applying the color `white` to every pixel of the lcd
; --------------------------------------------------
clearScreen:
    ld a,$FF
    ld bc,vRamEnd-vRam
    ld hl,vRam
    call _MemSet
; --------------------------------------------------
; Main game loop
; --------------------------------------------------
main_loop:
    ld a,(done)
    cp 1
    jr Z,clean
    call processInput
    call update
    call render
    jr main_loop
; --------------------------------------------------
; Processes the user input key commands
; 
; Note: Subsequent labels underneath handle the specified user input
; --------------------------------------------------
processInput:
    call _getKey
    cp k1
    call Z,keyOnePressed
    cp k2
    call Z,keyTwoPressed
    cp k3
    call Z,keyThreePressed
    cp k4
    call Z,keyFourPressed
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
    cp kClear
    call Z,keyClearPressed
    ret
keyOnePressed: ;point
    ret
keyTwoPressed: ;horizontal line
    ret
keyThreePressed: ;vertical line
    ret
keyFourPressed: ;square
    ret
keyEnterPressed: ;exit
keyClearPressed: ;exit
    ld a,1
    ld (done),a
    ret
keyUpPressed:
keyLeftPressed:
keyDownPressed:
keyRightPressed:
    ret
; --------------------------------------------------
; Performs an update of the application by changing subsequent values based on
; past user input
; --------------------------------------------------
update:
    ret
; --------------------------------------------------
; Renders the content
; --------------------------------------------------
render:
    ret