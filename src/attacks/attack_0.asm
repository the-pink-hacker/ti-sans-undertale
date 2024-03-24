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
    dl 001, attack.general.update.exit ; Omitted update to save space.
    dl 005 ; spawn bones
    dl 032 ; bones
    dl 001 ; bones & spawn gaster blasters
    dl 011 ; bones & move gaster blasters in
    dl 006 ; bones & gaster blasters
    dl 003 ; gaster blasters
    dl 003 ; swelling up of gaster blasters
    dl 001 ; fire
    dl 001 ; spawn next gb & fire
    dl 001,              attack.general.update.exit ; Omitted update to save space.

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

