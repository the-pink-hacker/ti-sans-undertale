jump_amount := 32

player.blue.update:
; ix = flags
    ld c, 0

    .jump_trigger:
        bit flags.input.up_bit, (ix + flags.input.offset)
        jq z, .jump_trigger_cancel
        bit flags.collision.hard_down_bit, (ix + flags.collision.offset)
        jq z, .jump_trigger_end

        ld (ix + flags.player_jump_counter.offset), jump_amount
        jp .jump_force_condition_skip
    .jump_trigger_cancel:
        ld (ix + flags.player_jump_counter.offset), 0
    .jump_trigger_end:

    .jump_force:
        ld a, (ix + flags.player_jump_counter.offset)
        or a, a
        jq z, .jump_force_end
    .jump_force_condition_skip:
        dec c
        dec c
        dec (ix + flags.player_jump_counter.offset)
        jp .gravity_end
    .jump_force_end:

    .gravity:
        bit flags.collision.hard_down_bit, (ix + flags.collision.offset)
        jq nz, .gravity_end

        inc c
        inc c
    .gravity_end:

    ld a, (ix + flags.player_soul_y.offset)
    add a, c
    ld (ix + flags.player_soul_y.offset), a

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

player.blue.draw:
; ix = flags
    ld hl, (ix + flags.player_soul_y.offset)
    push hl ; y
        ld hl, (ix + flags.player_soul_x.offset)
        push hl ; x
            ld hl, sprites.heart_blue
            push hl ; sprite
                call gfx.Sprite_NoClip
            pop hl
        pop hl
    pop hl

    ret
