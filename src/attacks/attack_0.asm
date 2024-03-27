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
    dl 001, .update.move_wave_bones_gb_a4_spawn,          .draw.wave_bones_gb_a4
    dl 029, .update.move_wave_bones_gb_a4,                .draw.wave_bones_gb_a4
    dl 999, .update.move_wave_bones,                      .draw.wave_bones_gb_a4
    dl 001, attack.general.update.exit ; Omitted update to save space.
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
    
    .move_wave_bones_gb_a4_spawn:
        ld (iy + entity_buffer.gb_a4), 0

        assert $ = .move_wave_bones_gb_a4

    .move_wave_bones_gb_a4:
        ld d, 6
        ld e, (iy + entity_buffer.gb_a4)
        inc (iy + entity_buffer.gb_a4)
        mlt de
        ld hl, attack.gaster_blaster_table
        add hl, de

        ld a, (hl)
        ld (iy + entity_buffer.gb_a4 + 1), a

        inc hl

        ld de, (hl)
        ld (iy + entity_buffer.gb_a4 + 2), de

        inc hl
        inc hl
        inc hl

        ld de, (hl)
        push de
            call gaster_blaster.get_sprite
        pop de

        ld (entity_buffer.start + entity_buffer.gb_a4 + 5), hl

        assert $ = .move_wave_bones
    
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

attack.gaster_blaster_table:
    repeat 30, index: 0
        db index ; y
        dl index ; x
        db index mod 6 ; frame
        db index mod 20 ; rotation
    end repeat

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

    .wave_bones_gb_a4:
        ;ld hl, 0
        ld l, (iy + entity_buffer.gb_a4 + 1)
        push hl ; y
            ;ld hl, 0
            ld hl, (iy + entity_buffer.gb_a4 + 2)
            push hl ; x
                ld hl, (iy + entity_buffer.gb_a4 + 5)
                ;ld hl, sprites.heart_red
                push hl ; sprite
                    call gfx.Sprite_NoClip
                pop hl
            pop hl
        pop hl

        ;call draw.set_clip_region_screen

        ;gaster_blaster_blast (4.0 * PI) / 3.0, box_x + box_size / 2, box_y + box_size / 2
        ;
        ;ld hl, ya2
        ;push hl ; y2
        ;    ld hl, xa2
        ;    push hl ; x2
        ;        ld hl, ya1
        ;        push hl ; y1
        ;            ld hl, xa1
        ;            push hl ; x1
        ;                ld hl, ya0
        ;                push hl ; y0
        ;                    ld hl, xa0
        ;                    push hl ; x0
        ;                        call gfx.FillTriangle
        ;                    pop hl
        ;                pop hl
        ;            pop hl
        ;        pop hl
        ;    pop hl
        ;pop hl
        ;
        ;ld hl, yb2
        ;push hl ; y2
        ;    ld hl, xb2
        ;    push hl ; x2
        ;        ld hl, yb1
        ;        push hl ; y1
        ;            ld hl, xb1
        ;            push hl ; x1
        ;                ld hl, yb0
        ;                push hl ; y0
        ;                    ld hl, xb0
        ;                    push hl ; x0
        ;                        call gfx.FillTriangle
        ;                    pop hl
        ;                pop hl
        ;            pop hl
        ;        pop hl
        ;    pop hl
        ;pop hl
        ;
        ;call draw.set_clip_region_box

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

