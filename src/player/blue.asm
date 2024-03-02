jump_amount := 32

player.blue.update:
; ix = flags
    ld hl, box_size - (2 * box_thickness)
    push hl, hl ; box_size
        ld l, box_y + box_thickness
        push hl ; box_y
            ld hl, box_x + box_thickness
            push hl ; box_x
                call check_hard_collision_inner_box
            pop hl
        pop hl
    pop hl, hl

    ld hl, player.heart.location_y

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
        dec (hl)
        dec (ix + flags.player_jump_counter.offset)
        jp .gravity_end
    .jump_force_end:

    .gravity:
        bit flags.collision.hard_down_bit, (ix + flags.collision.offset)
        jq nz, .gravity_end

        inc (hl)
    .gravity_end:

    inc hl ; *player.heart.location_x

    .input_left:
        bit flags.input.left_bit, (ix + flags.input.offset)
        jq z, .input_left_end
        bit flags.collision.hard_left_bit, (ix + flags.collision.offset)
        jq nz, .input_left_end

        dec (hl)
    .input_left_end:

    .input_right:
        bit flags.input.right_bit, (ix + flags.input.offset)
        jq z, .input_right_end
        bit flags.collision.hard_right_bit, (ix + flags.collision.offset)
        jq nz, .input_right_end

        inc (hl)
    .input_right_end:

    ret

player.blue.draw:
; ix = flags
    ld hl, player.heart.location_y
    ld e, (hl)
    push de ; y
        inc hl
        ld de, (hl)
        push de ; x
            ld hl, sprites.heart_blue
            push hl ; sprite
                call gfx.Sprite_NoClip
            pop hl
        pop hl
    pop hl

    ret
