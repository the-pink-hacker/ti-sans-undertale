game:
    .start:
        ld hl, 1
	push hl
        call gfx.SetDraw
	pop hl
    .loop:
    .input:
        call ti.GetCSC
	or a, a
	ret nz
        call gfx.SwapDraw

    .draw:
	call gfx.ZeroScreen

        ld hl, color
	ld de, (hl)
	inc (hl)
	push de ; color
	call gfx.SetColor
	pop hl

        ld hl, ti.lcdHeight / 2 - 8
	push hl ; radius
	ld hl, ti.lcdHeight / 2
	push hl ; y
	ld hl, ti.lcdWidth / 2
	push hl ; x
	call gfx.FillCircle
	pop hl, hl, hl

        jp .loop

color:
    db 0
