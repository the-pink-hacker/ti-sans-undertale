box_x := 117
box_y := 109
box_size := 86
box_thickness := 3

health_text_x := 207
health_text_y := 203

sans_x := 134
sans_y := 31

button_y := 214
button_fight_x := 15
button_act_x := 92
button_item_x := 172
button_mercy_x := 249

max_health := 95
health_bar_x := 128
health_bar_y := 200
health_bar_height := 10
health_bar_width := 55

color:
    .white := $FF
    .red := 111_00_000b
    .green := 000_00_111b
    .blue := 000_11_000b
    .yellow := .red or .green
    .cyan := .green or .blue
    .magenta := .blue or .red

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
        ; Blue heart
        ld a, flags.player_control.blue
        cp a, (ix + flags.player_control.offset)
        call z, player.blue.update

        ; Red heart
        ld a, flags.player_control.red
        cp a, (ix + flags.player_control.offset)
        call z, player.red.update

        ld a, (ix + flags.player_health.offset)
        sub a, (ix + flags.player_karma.offset) ; health - karma
        ld hl, 0
        ld l, a
        ld bc, health_lookup
        add hl, bc ; *health_bar_width
        ld a, (hl) ; health_bar_width
        ld d, a
        ld (ix + flags.player_health_width.offset), a

        ld hl, (ix + flags.player_karma.offset)
        add hl, bc ; *health_bar_width
        ld a, (hl)
        add a, d
        ld (ix + flags.player_karma_width.offset), a

    .draw:
        call gfx.ZeroScreen

        ld a, flags.player_control.blue
        cp a, (ix + flags.player_control.offset)
        call z, player.blue.draw

        ld a, flags.player_control.red
        cp a, (ix + flags.player_control.offset)
        call z, player.red.draw

        ; Sans
        ld l, sans_y
        push hl ; y
            ld hl, sans_x
            push hl ; x
                ld hl, sprites.sans
                push hl ; sprite
                    call gfx.Sprite_NoClip
                pop hl
            pop hl
        pop hl

        set_color color.red

        ld l, health_bar_height
        push hl ; height
            ld hl, health_bar_width
            push hl ; width
                ld l, health_bar_y
                push hl ; y
                    ld hl, health_bar_x
                    push hl ; x
                        call gfx.FillRectangle_NoClip
                    pop hl
                pop hl
            pop hl
        pop hl

        set_color color.magenta

        ld l, health_bar_height
        push hl ; height
            ld hl, (ix + flags.player_karma_width.offset)
            push hl ; width
                ld l, health_bar_y
                push hl ; y
                    ld hl, health_bar_x
                    push hl ; x
                        call gfx.FillRectangle_NoClip
                    pop hl
                pop hl
            pop hl
        pop hl

        set_color color.yellow
        
        ld l, health_bar_height
        push hl ; height
            ld hl, (ix + flags.player_health_width.offset)
            push hl ; width
                ld l, health_bar_y
                push hl ; y
                    ld hl, health_bar_x
                    push hl ; x
                        call gfx.FillRectangle_NoClip
                    pop hl
                pop hl
            pop hl
        pop hl

        xor a, a
        cp a, (ix + flags.player_karma.offset)
        jq nz, .draw.health_text.karma

        ld l, color.white
        jp .draw.health_text.karam_skip
    .draw.health_text.karma:
        ld l, color.magenta
    .draw.health_text.karam_skip:
        push hl ; color
            call font.SetForegroundColor
        pop hl

        call font.HomeUp

        ld a, (ix + flags.player_health.offset)
        call number_to_string_99

        ld hl, health_text
        ld (hl), e
        inc hl
        ld (hl), d
        dec hl
        push hl ; string
            call font.DrawString
        pop hl

        set_color color.white

    .draw.box:
        ld b, box_thickness
        ld hl, box_size
        ld c, box_y
        ld de, box_x
    .draw.box.loop:
        push bc
            push hl, hl ; height, width
                push bc ; box_y
                    push de
                        call gfx.Rectangle_NoClip
                    pop de
                pop bc
            pop hl, hl
        pop bc

        dec l ; box_size + 2
        dec l ; Save some cycles by not increasing hl

        inc c ; box_y + 1
        inc de ; box_x - 1

        djnz .draw.box.loop
    .draw.box_end:

        ld l, button_y
        push hl
            ld bc, button_fight_x
            push bc
                ld de, sprites.button_fight
                push de
                    call gfx.Sprite_NoClip
                pop de
            pop bc
        pop hl

        push hl
            ld bc, button_act_x
            push bc
                ld de, sprites.button_act
                push de
                    call gfx.Sprite_NoClip
                pop de
            pop bc
        pop hl

        push hl
            ld bc, button_item_x
            push bc
                ld de, sprites.button_item
                push de
                    call gfx.Sprite_NoClip
                pop de
            pop bc
        pop hl

        push hl
            ld bc, button_mercy_x
            push bc
                ld de, sprites.button_mercy
                push de
                    call gfx.Sprite_NoClip
                pop de
            pop bc
        pop hl

        jp .loop

health_lookup:
    repeat max_health + 1, index: 0
        db (index * health_bar_width) / max_health
    end repeat

flags:
    ; Current keys being pressed
    .input.left_bit  := ti.kbitLeft
    .input.down_bit  := ti.kbitDown
    .input.right_bit := ti.kbitRight
    .input.up_bit    := ti.kbitUp
    .input.use_bit   := 4
    .input.back_bit  := 5
    label_with_offset .input
        db 0

    ; The current input controller
    .player_control.dialog := 0
    .player_control.menu   := 1
    .player_control.red    := 2
    .player_control.blue   := 3
    label_with_offset .player_control
        db .player_control.red

    ; Which side of the player is being collided
    .collision.left_bit  := 0
    .collision.down_bit  := 1
    .collision.right_bit := 2
    .collision.up_bit    := 3
    label_with_offset .collision
        db 0

    ; How many frames should a jump force be applied
    label_with_offset .player_jump_counter
        db 0

    ; 24-bit so it can be loaded in both 8-bit and 24-bit registers
    ; Should always fit within 8-bit registers
    label_with_offset .player_health
        dl max_health - 10

    label_with_offset .player_karma
        dl 15

    ; Calculated on runtime
    label_with_offset .player_health_width
        dl 0

    ; Calculated on runtime
    label_with_offset .player_karma_width
        dl 0
