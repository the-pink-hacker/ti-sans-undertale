jump_force := 16

player.blue.update:
; ix = flags
    call reset_collision_flags

    ld iy, player.heart
    push iy ; player
        ld hl, (box_size - (2 * box_thickness)) or ((box_size - (2 * box_thickness)) shl 8)
        push hl ; box_size
            ld l, box_y + box_thickness
            push hl ; box_y
                ld hl, box_x + box_thickness
                push hl ; box_x
                    call check_collision_inner_box
                pop hl
            pop hl
        pop hl
    pop iy


    .grounded:
        bit flags.collision.down_bit, (ix + flags.collision.offset)
        jq z, .grounded_end

        ld (iy + player.heart.velocity_y.offset), 0
        jp .gravity_end
    .grounded_end:

    .gravity:
        ld a, 1
        cp a, (iy + player.heart.velocity_y.offset)
        jq c, .gravity_end

        inc (iy + player.heart.velocity_y.offset) ; Apply down velocity
    .gravity_end:

    .input_up:
        bit flags.input.up_bit, (ix + flags.input.offset)
        jq z, .input_up_end
        ld a, (ix + flags.collision.offset)
        bit flags.collision.up_bit, a
        jq z, .input_up_end
        bit flags.collision.down_bit, a
        jq nz, .input_up_end

        ld (iy + player.heart.jump.offset), jump_force
    .input_up_end:
    
    
    .apply_jump_force:
        ld a, (iy + player.heart.jump.offset)
        or a, a
        ld a, (iy + player.heart.location_y.offset)
        jq z, .apply_jump_force_end

        sub a, 5
        dec (iy + player.heart.jump.offset)
    .apply_jump_force_end:

    add a, (iy + player.heart.velocity_y.offset)
    ld (iy + player.heart.location_y.offset), a

    ld hl, (iy + player.heart.location_x.offset)

    .input_left:
        bit flags.input.left_bit, (ix + flags.input.offset)
        jq z, .input_left_end
        bit flags.collision.left_bit, (ix + flags.collision.offset)
        jq nz, .input_left_end

        dec hl
    .input_left_end:

    .input_right:
        bit flags.input.right_bit, (ix + flags.input.offset)
        jq z, .input_right_end
        bit flags.collision.right_bit, (ix + flags.collision.offset)
        jq nz, .input_right_end

        inc hl
    .input_right_end:

    ld (iy + player.heart.location_x.offset), hl

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
