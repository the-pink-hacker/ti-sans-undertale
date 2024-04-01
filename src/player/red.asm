player.red.update:
; ix = flags
    .input_down:
        bit flags.input.down_bit, (ix + flags.input.offset)
        jq z, .input_down_end
        bit flags.collision.hard_down_bit, (ix + flags.collision.offset)
        jq nz, .input_down_end

        inc (ix + flags.player_soul_y.offset)
        inc (ix + flags.player_soul_y.offset)
    .input_down_end:

    .input_up:
        bit flags.input.up_bit, (ix + flags.input.offset)
        jq z, .input_up_end
        bit flags.collision.hard_up_bit, (ix + flags.collision.offset)
        jq nz, .input_up_end

        dec (ix + flags.player_soul_y.offset)
        dec (ix + flags.player_soul_y.offset)
    .input_up_end:
    
    .input_left:
        bit flags.input.left_bit, (ix + flags.input.offset)
        jq z, .input_left_end
        bit flags.collision.hard_left_bit, (ix + flags.collision.offset)
        jq nz, .input_left_end

        ld hl, (ix + flags.player_soul_x.offset)
        dec hl
        dec hl
        ld (ix + flags.player_soul_x.offset), hl
    .input_left_end:

    .input_right:
        bit flags.input.right_bit, (ix + flags.input.offset)
        jq z, .input_right_end
        bit flags.collision.hard_right_bit, (ix + flags.collision.offset)
        jq nz, .input_right_end

        ld hl, (ix + flags.player_soul_x.offset)
        inc hl
        inc hl
        ld (ix + flags.player_soul_x.offset), hl
    .input_right_end:

    ret

player.red.draw:
; ix = flags
    ld hl, (ix + flags.player_soul_y.offset)
    push hl ; y
        ld hl, (ix + flags.player_soul_x.offset)
        push hl ; x
            ld hl, sprites.heart_red
            push hl ; sprite
                call gfx.Sprite_NoClip
            pop hl
        pop hl
    pop hl

    ret
