attack.attack_0:
    dl 080, NULL,                                         NULL
    dl 001, attack.general.update.set_player_soul_blue,   NULL
    dl 050, attack.general.update.throw_player_soul_down, NULL
    dl 001, .update.spawn_bottom_bone_block,              .draw.bone_block
    dl 010, .update.bone_block_move_up,                   .draw.bone_block
    dl 030, .update.bone_block_collision,                 .draw.bone_block
    dl 001, attack.general.update.set_player_soul_red,    .draw.bone_block
    dl 030, .update.bone_block_collision,                 .draw.bone_block
    dl 010, .update.bone_block_move_down,                 .draw.bone_block
    dl 005, NULL,                                         NULL
    dl 001, .update.spawn_wave_bones,                     .draw.wave_bones
    dl 032, .update.move_wave_bones,                      .draw.wave_bones
    dl 999, NULL,                                         .draw.wave_bones_gb
    dl 001, attack.general.update.exit ; Omitted update to save space.
    dl 032 ; bones
    dl 001 ; bones & spawn gaster blasters
    dl 011 ; bones & move gaster blasters in
    dl 006 ; bones & gaster blasters
    dl 003 ; gaster blasters
    dl 003 ; swelling up of gaster blasters
    dl 001 ; fire
    dl 001 ; spawn next gb & fire
    dl 001, attack.general.update.exit ; Omitted update to save space.

attack.attack_0.update:
    .spawn_bottom_bone_block:
        ld (iy), box_y + box_size ; y
        ld hl, box_x + (box_size - sprites.bones_horizontal.width) / 2 ; x
        ld (iy + 1), hl
        ret

    .bone_block_move_up:
        dec (iy)
        dec (iy)
    assert $ = .bone_block_collision

    .bone_block_collision:
        ld l, sprites.bones_horizontal.height
        push hl ; box_size_y
            ld hl, sprites.bones_horizontal.width
            push hl ; box_size_x
                ld l, (iy)
                push hl ; box_y
                    ld hl, (iy + 1)
                    push hl ; box_x
                        call check_soft_collision_box
                    pop hl
                pop hl
            pop hl
        pop hl

        ret

    .bone_block_move_down:
        inc (iy)
        inc (iy)
        jp .bone_block_collision

    .spawn_wave_bones:
        ld hl, attack.wave_bones_table
        ld de, entity_buffer.bones
        ld bc, attack.wave_bones_table.size
        ldir
        
        ret
    
    .move_wave_bones:
        ld hl, entity_buffer.bones
        ld b, attack.wave_bones_table.length

        .loop:
            ld iy, (hl)
            ld de, 3
            add iy, de
            ld (hl), iy

            push bc
                push hl
                    add hl, de
                    ld c, (hl)
                    inc hl
                    ld hl, (hl)
                    add hl, de
                    add hl, de
                    push hl ; box_size_y
                        ld de, sprites.bone_top.width
                        push de ; box_size_x
                            push bc ; box_y
                                push iy ; box_x
                                    call check_soft_collision_box
                                pop hl
                            pop hl
                        pop hl
                    pop hl
                pop hl

                ld de, attack.wave_bones_table.bone_length
                add hl, de

            pop bc
            djnz .loop

        ret

attack.wave_bones_table:
    .length := 40

    repeat .length / 2, index: 0
        radians = (index / 20.0) * TAU * 1.25
        sin radians, TRIG_ITERATIONS
        height_offset = 26
        height_shift = -10
        wave_height = trunc (result * 10.0)
        spacing = 10
        x = box_x - (spacing * index) - 1

        dl x
        db box_y
        db height_offset + wave_height + height_shift

        dl x
        height = height_offset - wave_height
        db box_y + box_size - sprites.bone_top.height - sprites.bone_bottom.height - height + height_shift
        db height - height_shift
    end repeat

    .size := $ - .
    .bone_length := .size / .length

attack.attack_0.draw:
    .bone_block:
        ld hl, 0
        ld l, (iy)
        push hl ; y
            ld hl, (iy + 1)
            push hl ; x
                ld hl, sprites.bones_horizontal
                push hl ; sprite
                    call gfx.TransparentSprite
                pop hl
            pop hl
        pop hl
        ret

    .wave_bones_gb:
        call draw.set_clip_region_screen

        xgb := box_x + box_size / 2
        ygb := box_y + box_size / 2
        radius := 10
        length := 325
        quarter := PI / 2.0
        rotation := (4.0 * PI) / 3.0 - quarter
        side_rotation := rotation - quarter
        side_alt_rotation := rotation + quarter

        cos side_rotation, TRIG_ITERATIONS
        xa0 := trunc (result * radius) + xgb ; cos(rotation) * radius
        sin side_rotation, TRIG_ITERATIONS
        ya0 := trunc (result * radius) + ygb ; sin(rotation) * radius

        cos rotation, TRIG_ITERATIONS
        x_end := trunc (result * length) + xgb
        sin rotation, TRIG_ITERATIONS
        y_end := trunc (result * length) + ygb

        cos side_rotation, TRIG_ITERATIONS
        xa1 := trunc (result * radius) + x_end
        sin side_rotation, TRIG_ITERATIONS
        ya1 := trunc (result * radius) + y_end

        cos side_alt_rotation, TRIG_ITERATIONS
        xa2 := trunc (result * radius) + x_end
        sin side_alt_rotation, TRIG_ITERATIONS
        ya2 := trunc (result * radius) + y_end

        xb0 := xa0
        yb0 := ya0
        
        cos side_alt_rotation, TRIG_ITERATIONS
        xb1 := trunc (result * radius) + xgb
        sin side_alt_rotation, TRIG_ITERATIONS
        yb1 := trunc (result * radius) + ygb

        xb2 := xa2
        yb2 := ya2

        ld hl, ya2
        push hl ; y2
            ld hl, xa2
            push hl ; x2
                ld hl, ya1
                push hl ; y1
                    ld hl, xa1
                    push hl ; x1
                        ld hl, ya0
                        push hl ; y0
                            ld hl, xa0
                            push hl ; x0
                                call gfx.FillTriangle
                            pop hl
                        pop hl
                    pop hl
                pop hl
            pop hl
        pop hl

        ld hl, yb2
        push hl ; y2
            ld hl, xb2
            push hl ; x2
                ld hl, yb1
                push hl ; y1
                    ld hl, xb1
                    push hl ; x1
                        ld hl, yb0
                        push hl ; y0
                            ld hl, xb0
                            push hl ; x0
                                call gfx.FillTriangle
                            pop hl
                        pop hl
                    pop hl
                pop hl
            pop hl
        pop hl

        call draw.set_clip_region_box

        assert $ = .wave_bones

    .wave_bones:
        ld b, attack.wave_bones_table.length
        ld iy, entity_buffer.bones

        .loop:
            call draw.bone_horizontal

            ld de, attack.wave_bones_table.bone_length
            add iy, de
            djnz .loop

        ret

