attack.attack_0:
    dl 03 * target_fps, NULL,                                         NULL
    dl 01,              attack.general.update.set_player_soul_blue,   NULL
    dl 50,              attack.general.update.throw_player_soul_down, NULL
    dl 01,              .update.spawn_bottom_bone_block,              NULL
    dl 10,              .update.bone_block_move_up,                   .draw.bone_block
    dl 01 * target_fps, .update.bone_block_collision,                 .draw.bone_block
    dl 01,              attack.general.update.set_player_soul_red,    .draw.bone_block
    dl 01 * target_fps, .update.bone_block_collision,                 .draw.bone_block
    dl 10,              .update.bone_block_move_down,                 .draw.bone_block
    dl 01,              attack.general.update.exit ; Omitted update to save space.

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
        ld l, (iy)
        push hl ; y
            ld hl, (iy + 1)
            push hl ; x
                ld hl, sprites.bones_horizontal
                push hl ; sprite
                    call gfx.TransparentSprite_NoClip
                pop hl
            pop hl
        pop hl
        ret

