box_x := 117
box_y := 109
box_size := 86
box_thickness := 3

sans_x := 134
sans_y := 31

button_y := 214
button_fight_x := 15
button_act_x := 92
button_item_x := 172
button_mercy_x := 249

max_health := 92
health_bar_x := 128
health_bar_y := 200
health_bar_height := 10
health_bar_width := 55

target_fps := 30

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

        call draw.set_clip_region_box
        call attack.load_attack
    .loop:
        call gfx.SwapDraw

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

    .update:
        ld (ix + flags.collision.offset), 0

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

    .update.attack:
        bit flags.attack.attack_loaded_bit, (ix + flags.attack.offset)
        jq z, .update.attack_end

        or a, a ; Resets carry.
        ld hl, (ix + flags.frame_counter.offset)
        ld bc, (ix + flags.frame_counter_attack_step_end.offset)
        sbc hl, bc
        call z, attack.advance_step

        call attack.run_update_step
    .update.attack_end:

    .update.damage:
        ; TODO: Rewrite all of this );
        bit flags.collision.soft_bit, (ix + flags.collision.offset)
        jq z, .update.damage_end

        ld a, (ix + flags.player_health.offset)
        dec a
        ld (ix + flags.player_health.offset), a
        jq z, .update.damage_end
    .update.damage_karma:
        sub a, (ix + flags.player_karma.offset) ; Health left after karma
        ; carry => lower karma
        ; non-zero => karam += 1
        jq nc, .update.damage_karma_increase

        ;ld (ix + flags.player_karma.offset), 0
        add a, (ix + flags.player_karma.offset)
        dec a
        ld (ix + flags.player_karma.offset), a ; Keep health above 0 after karma.
        jp .update.damage_end
    .update.damage_karma_increase:
        jq z, .update.damage_end

        inc (ix + flags.player_karma.offset)
    .update.damage_end:

        ; Blue heart
        ld a, flags.player_control.blue
        cp a, (ix + flags.player_control.offset)
        call z, player.blue.update

        ; Red heart
        ld a, flags.player_control.red
        cp a, (ix + flags.player_control.offset)
        call z, player.red.update

    .update.schedule_second:
        xor a, a ; Reset carry
        ld hl, (ix + flags.frame_counter.offset)
        ld de, (ix + flags.frame_counter_next_second.offset)
        sbc hl, de
        jq nz, .update.schedule_second_end

        cp a, (ix + flags.player_karma.offset)
        jq z, .update.karma_skip

        dec (ix + flags.player_karma.offset)
        dec (ix + flags.player_health.offset)
    .update.karma_skip:
        ld hl, target_fps
        add hl, de
        ld (ix + flags.frame_counter_next_second.offset), hl
    .update.schedule_second_end:
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

        ; Update hud text
        ld a, (ix + flags.player_health.offset)
        call number_to_string_99

        ld hl, text.hud.health.number
        ld (hl), e
        inc hl
        ld (hl), d

        ; DEBUG FLOAT TEXT
        display_decimal $
        ld hl, float_value
        call ti.Mov9ToOP1

        call float_op1_to_u8

        call number_to_string_99

        ld hl, text_float + 1
        ld (hl), e
        inc hl
        ld (hl), d

    .update.end:
        ld hl, (ix + flags.frame_counter.offset)
        inc hl
        ld (ix + flags.frame_counter.offset), hl

    .draw:
        call gfx.ZeroScreen ; V-sync

        ld l, 0
        push hl
            call gfx.SetDraw
        pop hl
        call gfx.SwapDraw ; V-sync
                          ; Very cursed );

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
            call font.HomeUp
            
            ld l, color.white
            push hl
                call font.SetForegroundColor
                call gfx.SetColor
            pop hl

            ld hl, text.hud.character
            push hl ; string
                call font.DrawString
            pop hl

            ld hl, 203
            push hl ; y
                push hl ; y
                    ld l, text.hud.level.x
                    push hl ; x
                        call font.SetCursorPosition
                    pop hl
                
                    ld hl, text.hud.level
                    push hl
                        call font.DrawString
                    pop hl
                pop hl

                ld l, text.hud.health.x
                push hl
                    call font.SetCursorPosition
                pop hl
            pop hl

            call font.SetForegroundColor
        pop hl

        ld hl, text.hud.health
        push hl
            call font.DrawString
        pop hl

        ld hl, text_float
        push hl
            call font.DrawString
        pop hl

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

        dec hl ; box_size + 2
        dec hl

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

            ld bc, button_act_x
            push bc
                ld de, sprites.button_act
                push de
                    call gfx.Sprite_NoClip
                pop de
            pop bc

            ld bc, button_item_x
            push bc
                ld de, sprites.button_item
                push de
                    call gfx.Sprite_NoClip
                pop de
            pop bc

            ld bc, button_mercy_x
            push bc
                ld de, sprites.button_mercy
                push de
                    call gfx.Sprite_NoClip
                pop de
            pop bc
        pop hl

    .draw.attack:
        bit flags.attack.attack_loaded_bit, (ix + flags.attack.offset)
        jq z, .draw.attack_end

        call attack.run_draw_step
    .draw.attack_end:

        jp .loop

health_lookup:
    repeat max_health + 1, index: 0
        db trunc (((index * health_bar_width) / float (max_health)) + 0.5)
    end repeat

text_float:
    string " 00"

float_value:
    db 0000_0001b ; Positive | Real
    db $81 ; Exponent
    db $68
    db $55
    rb 5

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

    label_with_offset .frame_counter
        dl 0

    label_with_offset .frame_counter_next_second
        dl target_fps

    label_with_offset .frame_counter_attack_step_end
        dl 0

    label_with_offset .current_attack
        dl attack.attack_0

    .attack.attack_loaded_bit := 0
    label_with_offset .attack
        db 0

    ; The current input controller
    .player_control.dialog := 0
    .player_control.menu   := 1
    .player_control.red    := 2
    .player_control.blue   := 3
    label_with_offset .player_control
        db .player_control.red

    ; Which side of the player is being collided.
    ; Player can't pass through hard collisions (e.g. platforms, box).
    .collision.hard_left_bit  := 0
    .collision.hard_down_bit  := 1
    .collision.hard_right_bit := 2
    .collision.hard_up_bit    := 3
    ; Player can pass through soft collisions (e.g. bones).
    .collision.soft_bit       := 4
    label_with_offset .collision
        db 0

    ; How many frames should a jump force be applied
    label_with_offset .player_jump_counter
        db 0

    ; 24-bit so it can be loaded in both 8-bit and 24-bit registers
    ; Should always fit within 8-bit registers
    label_with_offset .player_health
        dl max_health

    label_with_offset .player_karma
        dl 0

    label_with_offset .player_health_width
        dl NULL

    label_with_offset .player_karma_width
        dl NULL

    .program.exit_bit := 0
    label_with_offset .program
        db 0

    label_with_offset .player_soul_y
        db box_y + (box_size - sprites.heart_red.height) / 2

    label_with_offset .player_soul_x
        dl box_x + (box_size - sprites.heart_red.width) / 2
