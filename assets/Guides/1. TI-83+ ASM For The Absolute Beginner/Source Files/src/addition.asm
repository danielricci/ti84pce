#include "ti84pce.inc"
.nolist
.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

Operand1 .equ 55
Operand2 .equ 67

	call _homeup
	call _ClrScrnFull
	ld a,Operand1
	add a,Operand2
	ld hl,0
	ld l,a
	call _DispHL
	call _GetKey
	call _ClrScrnFull
	.list
	res donePrgm,(iy+doneFlags)

	ret
