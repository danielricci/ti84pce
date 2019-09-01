LCD_CopyHL1555Palette:
    ld hl,mpLcdPalette
    ld b,0
copyHL1555Palette_Loop:
    ld d,b
    ld a,b
    and %11000000
    srl d
    rra
    ld e,a
    ld a,%00011111
    and b
    or e
    ld (hl),a
    inc hl
    ld (hl),d
    inc hl
    inc b
    jr nz,copyHL1555Palette_Loop
    call _boot_ClearVRAM
    ld a,lcdBpp8
    ld (mpLcdCtrl),a
    ret
LCD_ResetPalette:
    ld a,lcdBpp16
    ld (mpLcdCtrl),a