entity_buffer := ti.pixelShadow2

attack_step_size := 9

attack.load_attack:
    set flags.attack.attack_loaded_bit, (ix + flags.attack.offset)
    ld iy, (ix + flags.current_attack.offset)
    jp attack.advance_step.load_attack_jump

attack.advance_step:
    ld iy, (ix + flags.current_attack.offset)
    ld bc, attack_step_size
    add iy, bc ; Advance to next step
    ld (ix + flags.current_attack.offset), iy

    .load_attack_jump:

    ld hl, (ix + flags.frame_counter.offset)
    ld bc, (iy)
    add hl, bc ; Advance step counter
    ld (ix + flags.frame_counter_attack_step_end.offset), hl

    ld hl, (iy + 3) ; update
    ld (attack.update_step), hl

    ld hl, (iy + 6) ; draw
    ld (attack.draw_step), hl
    ret

attack:
    .run_update_step:
        ld iy, entity_buffer
    .update_step := $ + 1
        ld hl, NULL ; SMC: will be changed to current step.
        ld de, NULL
        or a, a ; Reset carry.
        adc hl, de ; Has to be an adc since it affects the zero flag.
        ret z ; Return if null pointer.
        jp (hl)

    .run_draw_step:
        ld iy, entity_buffer
    .draw_step := $ + 1
        ld hl, NULL ; SMC: will be changed to current step.
        ld de, NULL
        or a, a ; Reset carry.
        adc hl, de ; Has to be an adc since it affects the zero flag.
        ret z ; Return if null pointer.
        jp (hl)

example_attack:
    dl 1 * target_fps, NULL, NULL
    dl 2 * target_fps, .update.spawn, .draw.sprite
    dl 1 * target_fps, .update.move_left, .draw.sprite
    dl 1 * target_fps, .update.move_right, .draw.sprite
    dl 1 * target_fps, .update.move_left, .draw.sprite
    dl 1 * target_fps, .update.move_right, .draw.sprite
    dl 1 * target_fps, NULL, NULL
    dl 0, .exit, NULL

example_attack.update:
    .spawn:
        ld (iy), 100 ; y
        ld hl, 100
        ld (iy + 1), hl ; x
        ret

    .move_left:
        ld hl, (iy + 1)
        dec hl
        ld (iy + 1), hl
        ret

    .move_right:
        ld hl, (iy + 1)
        inc hl
        ld (iy + 1), hl
        ret

example_attack.draw:
    .sprite:
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

example_attack.exit:
    res flags.attack.attack_loaded_bit, (ix + flags.attack.offset)
    ret
    
include "src/attacks/gaster_blaster.asm"
