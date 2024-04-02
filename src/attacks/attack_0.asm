bottom_bone_move_amount := 8

attack.attack_0:
    dl 001, attack.general.update.set_player_soul_blue,   NULL
    dl 010, attack.general.update.throw_player_soul_down, NULL
    dl 015, NULL,                                         NULL
    dl 001, .update.spawn_bottom_bone_block,              .draw.bone_block
    dl 003, .update.bone_block_move_up,                   .draw.bone_block
    dl 025, .update.bone_block_collision,                 .draw.bone_block
    dl 001, attack.general.update.set_player_soul_red,    .draw.bone_block
    dl 030, .update.bone_block_collision,                 .draw.bone_block
    dl 003, .update.bone_block_move_down,                 .draw.bone_block
    dl 005, NULL,                                         NULL
    dl 001, .update.spawn_wave_bones,                     .draw.wave_bones
    dl 032, .update.move_wave_bones,                      .draw.wave_bones
    dl 001, .update.move_wave_bones_gb_a4_spawn,          .draw.wave_bones_gb_a4
    dl 011, .update.move_wave_bones_gb_a4,                .draw.wave_bones_gb_a4
    dl 006, .update.move_wave_bones,                      .draw.wave_bones_gb_a4
    dl 009, NULL,                                         .draw.gb_a4
    dl 001, .update.gb_a4_pre_charge,                     .draw.gb_a4
    dl 001, NULL,                                         .draw.gb_a4
    repeat 5
    dl 001, .update.gb_a4_charge,                         .draw.gb_a4
    dl 001, NULL,                                         .draw.gb_a4
    end repeat
    dl 090, NULL,                                         .draw.gb_a4
    dl 001, attack.general.update.exit ; Omitted update to save space.

attack.attack_0.update:
    .spawn_bottom_bone_block:
        ld (iy), box_y + box_size ; y
        ld hl, box_x + box_thickness ; x
        ld (iy + 1), hl
        ret

    .bone_block_move_up:
        ld a, (iy)
        sub a, bottom_bone_move_amount
        ld (iy), a
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
        ld a, (iy)
        add a, bottom_bone_move_amount
        ld (iy), a
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
        ld d, 5 * 4
        ld e, (iy + entity_buffer.gb_a4)
        inc (iy + entity_buffer.gb_a4)
        mlt de
        ld hl, attack.gaster_blaster_table
        add hl, de

        repeat 4, index: 0
            offset = index * 7

            ld a, (hl) ; y
            ld (iy + entity_buffer.gb_a4 + 1 + offset), a

            inc hl

            ld de, (hl) ; x
            ld (iy + entity_buffer.gb_a4 + 2 + offset), de

            inc hl
            inc hl
            inc hl

            if % <> %%
                push iy
                    push hl
            end if

                    ld d, (hl) ; rotation
                    ld e, 0 ; frame
                    push de
                        call gaster_blaster.get_sprite
                    pop de
                    
                    ld (entity_buffer.start + entity_buffer.gb_a4 + 5 + offset), hl

            if % <> %% ; Only needs to run if another repeat follows.
                    pop hl
                pop iy

                inc hl
            end if

        end repeat

        assert $ = .move_wave_bones
    
    .move_wave_bones:
        ld hl, entity_buffer.bones
        ld b, attack.wave_bones_table.length

        .loop:
            ld iy, (hl)
            ld de, 3
            add iy, de
            add iy, de
            ld (hl), iy ; x += 3

            push bc
                push hl
                    add hl, de
                    ld c, (hl) ; y
                    inc hl
                    ld l, (hl) ; height
                    add hl, de ; height += top
                    add hl, de ; height += bottom
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

    .gb_a4_pre_charge:
        ld (iy + entity_buffer.gb_a4), 0

        assert $ = .gb_a4_charge

    .gb_a4_charge:
        ld e, (iy + entity_buffer.gb_a4) ; frame
        inc (iy + entity_buffer.gb_a4)

        repeat 4, index: 0
            push iy
                ld d, index * 5 ; rotation
                push de
                    call gaster_blaster.get_sprite
                pop de
            pop iy

            ld (iy + entity_buffer.gb_a4 + 5 + 7 * index), hl
        end repeat

        ret

attack.gaster_blaster_table:
    repeat 12, index: 0
        rotation = (index * PI) / (2 * (%% - 1))
        sin rotation, TRIG_ITERATIONS ; Ease out

        db trunc (result * 53 + 0.5) ; y
        dl 16 + trunc (result * 83 + 0.5) ; x
        db 0 ; rotation
             ; Constant because Toby can do whatever he want to do...

        db 16 + trunc (result * 75 + 0.5) ; y
        dl trunc (result * 66 + 0.5) ; x
        db 2 + trunc (result * 3 + 0.5) ; rotation

        db ti.lcdHeight - 32 - trunc (result * 17 + 0.5) ; y
        dl ti.lcdWidth - 64 - trunc (result * 93 + 0.5); x
        db 16 - trunc (result * 6 + 0.5) ; rotation

        db ti.lcdHeight - 56 - trunc (result * 28 + 0.5) ; y
        dl ti.lcdWidth - 56 - trunc (result * 68 + 0.5) ; x
        db 18 - trunc (result * 3 + 0.5) ; rotation
    end repeat

attack.wave_bones_table:
    .length := 40

    repeat .length / 2, index: 0
        radians = (index / 20.0) * TAU * 1.25
        sin radians, TRIG_ITERATIONS
        height_offset = 26
        height_shift = -14
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

    .gb_a4:
        call draw.set_clip_region_screen

        repeat 4, index: 0
            offset = index * 7

            if % <> %% ; Only needs to run if another repeat follows.
                push iy
            end if

                ld hl, 0
                ld l, (iy + entity_buffer.gb_a4 + 1 + offset)
                push hl ; y
                    ld hl, (iy + entity_buffer.gb_a4 + 2 + offset)
                    push hl ; x
                        ld hl, (iy + entity_buffer.gb_a4 + 5 + offset)
                        push hl ; sprite
                            call gfx.TransparentSprite
                        pop hl
                    pop hl
                pop hl

            if % <> %%
                pop iy
            end if
        end repeat


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

        call draw.set_clip_region_box

        ret

    .wave_bones_gb_a4:
        call .gb_a4

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

