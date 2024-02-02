game:
    .start:
        ld ix, flags
    .loop:
    .input:
        ld l, 6
        push hl ; group
            call kb.ScanGroup
        pop hl
        bit ti.kbitClear, a
        ret nz

        inc l ; l = 7
        push hl ; group
            call kb.ScanGroup
        pop hl
        ld b, $0F ; Get d-pad values only.
        and a, b
        ld (ix + flags.input.offset), a

    .input.group_1:
        ld l, 1
        push hl ; group
            call kb.ScanGroup
        pop hl
        bit ti.kbit2nd, a
        jp z, .input.group_1_end

        set flags.input.use_bit, (ix + flags.input.offset)
        ld (ix + flags.player_control.offset), flags.player_control.red
    .input.group_1_end:

    .input.group_2:
        inc l ; l = 2
        push hl ; group
            call kb.ScanGroup
        pop hl
        bit ti.kbitAlpha, a
        jp z, .input.group_2_end

        set flags.input.back_bit, (ix + flags.input.offset)
        ld (ix + flags.player_control.offset), flags.player_control.blue
    .input.group_2_end:

    .pre_draw:
        call gfx.SwapDraw

    .update:
        ;ld ix, flags

        ; Blue heart
        ld a, flags.player_control.blue
        cp a, (ix + flags.player_control.offset)
        call z, player.blue.update

        ; Red heart
        ld a, flags.player_control.red
        cp a, (ix + flags.player_control.offset)
        call z, player.red.update

    .draw:
        call gfx.ZeroScreen

        ; Already is set to flags
        ;ld ix, flags

        ld a, flags.player_control.red
        cp a, (ix + flags.player_control.offset)
        call z, player.red.draw

        ld a, flags.player_control.blue
        cp a, (ix + flags.player_control.offset)
        call z, player.blue.draw

        ; Sans
        ld l, 45
        push hl ; y
            ld hl, 134
            push hl ; x
                ld hl, sprites.sans
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
                        ld hl, sprites.gaster_blaster
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
    .input.left_bit  := ti.kbitLeft
    .input.down_bit  := ti.kbitDown
    .input.right_bit := ti.kbitRight
    .input.up_bit    := ti.kbitUp
    .input.use_bit   := 4
    .input.back_bit  := 5
    .input.offset    := $ - .
    .input:
        db 0

    .player_control.dialog := 0
    .player_control.menu   := 1
    .player_control.red    := 2
    .player_control.blue   := 3
    .player_control.offset := $ - .
    .player_control:
        db .player_control.blue
