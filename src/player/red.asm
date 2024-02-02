player.red.update:
; ix = flags
        ld hl, angle
        inc (hl)

        ld hl, player.heart.location_y
        ld b, (hl)

    .input_down:
        bit flags.input.down_bit, (ix + flags.input.offset)
        jp z, .input_down_end
        inc b
    .input_down_end:

    .input_up:
        bit flags.input.up_bit, (ix + flags.input.offset)
        jp z, .input_up_end
        dec b
    .input_up_end:
        ld (hl), b

        inc hl ; hl = player.heart.location_x
        ld de, (hl)

    .input_left:
        bit flags.input.left_bit, (ix + flags.input.offset)
        jp z, .input_left_end
        dec de
    .input_left_end:

    .input_right:
        bit flags.input.right_bit, (ix + flags.input.offset)
        jp z, .input_right_end
        inc de
    .input_right_end:
        ld (hl), de
    
    .end:
        ret

player.red.draw:
; ix = flags
    ld hl, player.heart.location_y
    ld e, (hl)
    push de ; y
        inc hl
        ld de, (hl)
        push de ; x
            ld hl, sprites.heart_red
            push hl ; sprite
                call gfx.Sprite_NoClip
            pop hl
        pop hl
    pop hl

    ret
