#include "ti84pce.inc"

.assume ADL=1
.org userMem-2
.db tExtTok,tAsm84CeCmp

 call _homeup
 call _ClrScrnFull

 ld hl,TutorialText

 call _PutS
 call _GetKey
 call _ClrScrnFull

 res donePrgm,(iy+doneFlags)
 ret

TutorialText:
  .db "This is an example of some text.",0
