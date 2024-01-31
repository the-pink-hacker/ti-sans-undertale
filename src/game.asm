game:
    .start:
        call gfx.SetDraw
    .loop:
        call ti.GetCSC
	or a, a
    .draw:
        call gfx.SwapDraw

	jp z, .loop
    .exit:
	ret
