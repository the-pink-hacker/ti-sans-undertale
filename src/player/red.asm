player.red.update:
; ix = flags
    ld hl, box_size - (2 * box_thickness)
    push hl, hl ; box_size_x, box_size_y
        ld l, box_y + box_thickness
        push hl ; box_y
            ld hl, box_x + box_thickness
            push hl ; box_x
                call check_hard_collision_inner_box
            pop hl
        pop hl
    pop hl, hl

    ld l, sprites.bones_horizontal.height
    push hl ; box_size_y
        ld hl, sprites.bones_horizontal.width
        push hl ; box_size_x
            ld hl, test
            ld e, (hl)
            push de ; box_y
                inc hl
                ld de, (hl)
                push de ; box_x
                    call check_soft_collision_box
                pop hl
            pop hl
        pop hl
    pop hl

    ld hl, player.heart.location_y

    .input_down:
        bit flags.input.down_bit, (ix + flags.input.offset)
        jq z, .input_down_end
        bit flags.collision.hard_down_bit, (ix + flags.collision.offset)
        jq nz, .input_down_end

        inc (hl)
    .input_down_end:

    .input_up:
        bit flags.input.up_bit, (ix + flags.input.offset)
        jq z, .input_up_end
        bit flags.collision.hard_up_bit, (ix + flags.collision.offset)
        jq nz, .input_up_end

        dec (hl)
    .input_up_end:
    
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

    .damage:
        bit flags.collision.soft_bit, (ix + flags.collision.offset)
        jq z, .damage_end

        dec (ix + flags.player_health.offset)
    .damage_end:
    
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
