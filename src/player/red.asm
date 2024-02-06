player.red.update:
; ix = flags
    call reset_collision_flags

    ld hl, player.heart.location_y
    push hl ; player
        ld hl, $4040 ; 64, 64
        push hl ; box_size
            ld l, ti.lcdHeight - 64 - 32
            push hl ; box_y
                ld hl, (ti.lcdWidth / 2) - (64 / 2)
                push hl
                    call check_collision_inner_box
                pop hl
            pop hl
        pop hl
    pop hl

    ld b, (hl)

    .input_down:
        bit flags.input.down_bit, (ix + flags.input.offset)
        jq z, .input_down_end
        bit flags.collision.down_bit, (ix + flags.collision.offset)
        jq nz, .input_down_end

        inc b
    .input_down_end:

    .input_up:
        bit flags.input.up_bit, (ix + flags.input.offset)
        jq z, .input_up_end
        bit flags.collision.up_bit, (ix + flags.collision.offset)
        jq nz, .input_up_end

        dec b
    .input_up_end:
    
    ld (hl), b

    inc hl ; hl = player.heart.location_x
    ld de, (hl)

    .input_left:
        bit flags.input.left_bit, (ix + flags.input.offset)
        jq z, .input_left_end
        bit flags.collision.left_bit, (ix + flags.collision.offset)
        jq nz, .input_left_end

        dec de
    .input_left_end:

    .input_right:
        bit flags.input.right_bit, (ix + flags.input.offset)
        jq z, .input_right_end
        bit flags.collision.right_bit, (ix + flags.collision.offset)
        jq nz, .input_right_end

        inc de
    .input_right_end:

    ld (hl), de
    
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
