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

	; Player heart
        ld hl, player_heart.location_y
	ld e, (hl)
	push de ; y
	inc hl
	ld de, (hl)
	push de ; x
	ld hl, sprite_heart
	push hl
	call gfx.Sprite_NoClip
	pop hl, hl, hl

        jp .loop

player_heart:
    .location_y:
        db ti.lcdHeight / 2
    .location_x:
        dl ti.lcdWidth / 2

sprite_heart:
    .width:
        db 8
    .height:
        db 8
    data:
	; Placeholder data
        repeat 8 * 8
	    db $F0
	end repeat
