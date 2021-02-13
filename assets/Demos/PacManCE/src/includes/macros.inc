#define	popCall()	pop	hl

#macro	printf(string, posX, posY)
	ld	hl,string
	ld	bc,(posY/2)+(256*(posX/2))
	call	drawString
#endmacro

#macro fprintf(posX, posY)
	ld	bc,(posY/2)+(256*(posX/2))
	call	drawString
#endmacro

#macro	drawSpr255(sprite, posX, posY)
	ld	hl,sprite
	ld	bc,(posY)+(256*(posX))
	call	drawSprite
#endmacro

#macro drawSpr8bpp(sprite, posX, posY)
	push	af
	ld	hl,sprite
	ld	bc,(posY/2)+(256*(posX/2))
	call	drawSpriteDouble
	pop	af
#endmacro

#macro eraseRect(posX, posY, width, height)
	ld	h,width
	ld	l,height
	ld	bc,(posY)+(256*(posX))
	call	drawClearingRect
#endmacro

#macro relocate(new_location)
 #ifdef old_location
   .echo "Mateo: ",__file,":",__line,": error: You cannot nest relocate blocks."
 #else
   #define old_location eval($)
   .org new_location
   #define g_location eval(new_location)
 #endif
#endmacro

#macro endrelocate()
 #ifdef g_location
   .org $-g_location + old_location
   #undefine g_location
   #undefine old_location
 #else
   .echo "Error line ",__line,": No relocate statements corresponds to this endrelocate."
 #endif
#endmacro

#macro loadA(y, x)
 #if x = 0
	xor	a,a
	ld	(y),a
 #else
	ld	a,x
	ld	(y),a
 #endif
#endmacro

#macro loadHL(y, x)
 #if x = 0
	or	a,a
	sbc	hl,hl
	ld	(y),hl
 #else
	ld	hl,x
	ld	(y),hl
 #endif
#endmacro
