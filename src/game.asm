game:
    .start:
    .loop:
    .input:
        ld l, 6
        push hl
        call kb.ScanGroup
        pop hl
        bit ti.kbitClear, a
        ret nz

        inc l ; l = 7
        push hl
        call kb.ScanGroup
        pop hl
        ld b, $0F ; Get d-pad values only.
        and a, b
        ld ix, flags.input
        ld (ix), a

        ld l, 1
        push hl
        call kb.ScanGroup
        pop hl
        bit ti.kbit2nd, a
        jp z, .input_end
        set ti.kbit2nd, (ix)
    .input_end:

    .pre_draw:
        call gfx.SwapDraw

    .update:
        ld hl, angle
        inc (hl)

        ld a, (flags.input)
        ld hl, player_heart.location_y
        ld b, (hl)

    .update_player_heart_down:
        bit flags.input_down_bit, a
        jp z, .update_player_heart_down_end
        inc b
    .update_player_heart_down_end:

    .update_player_heart_up:
        bit flags.input_up_bit, a
        jp z, .update_player_heart_up_end
        dec b
    .update_player_heart_up_end:
        ld (hl), b

        inc hl ; hl = player_heart.location_x
        ld de, (hl)

    .update_player_heart_left:
        bit flags.input_left_bit, a
        jp z, .update_player_heart_left_end
        dec de
    .update_player_heart_left_end:

    .update_player_heart_right:
        bit flags.input_right_bit, a
        jp z, .update_player_heart_right_end
        inc de
    .update_player_heart_right_end:
        ld (hl), de

    .draw:
        call gfx.ZeroScreen

        ; Player heart
        ld hl, player_heart.location_y
        ld e, (hl)
        push de ; y
        inc hl
        ld de, (hl)
        push de ; x
        ld hl, heart_red
        push hl ; sprite
        call gfx.Sprite_NoClip
        pop hl, hl, hl

        ; Sans
        ld l, 45
        push hl ; y
            ld hl, 134
            push hl ; x
                ld hl, sans
                push hl ; sprite
                    call gfx.Sprite_NoClip
                pop hl
            pop hl
        pop hl

        ld hl, 64
        push hl ; scale
            ld hl, angle
            ld l, (hl)
            push hl ; angle
                ld l, 64
                push hl ; y
                    ld hl, ti.lcdWidth - 128
                    push hl ; x
                        ld hl, gaster_blaster
                        push hl ; 
                            call gfx.RotatedScaledTransparentSprite_NoClip
                        pop hl
                    pop hl
                pop hl
            pop hl
        pop hl

        jp .loop

angle:
    db 0

flags:
    .input_left_bit := ti.kbitLeft
    .input_down_bit := ti.kbitDown
    .input_right_bit := ti.kbitRight
    .input_up_bit := ti.kbitUp
    .input_use_bit := ti.kbit2nd
    .input:
        db 0

player_heart:
    .location_y:
        db ti.lcdHeight - 64
    .location_x:
        dl ti.lcdWidth / 2
