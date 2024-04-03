entity_buffer:
    .start := ti.pixelShadow2
    .size := 512
    .end := entity_buffer.start + entity_buffer.size

    .gb_a4 := 0
    ; frame: u8, 0
    ; gb_a4.x:
    ; x: i24, 0
    ; y: u8, 3
    ; sprite: *sprite, 4
    .gb_a4.end := .gb_a4 + 1 + 4 * 8

    .gb_b4 := .gb_a4.end
    .gb_b4.end := .gb_b4 + 1 + 4 * 8
    
    .bones := entity_buffer.start + 128
    .bones.end := .bones + attack.wave_bones_table.size
    assert .end >= .bones.end

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
    .update_step := $ + 1
        ld hl, NULL ; SMC: will be changed to current step.
        ld de, NULL
        or a, a ; Reset carry.
        adc hl, de ; Has to be an adc since it affects the zero flag.
        ret z ; Return if null pointer.
        ld iy, entity_buffer.start
        jp (hl)

    .run_draw_step:
    .draw_step := $ + 1
        ld hl, NULL ; SMC: will be changed to current step.
        ld de, NULL
        or a, a ; Reset carry.
        adc hl, de ; Has to be an adc since it affects the zero flag.
        ret z ; Return if null pointer.
        ld iy, entity_buffer.start
        jp (hl)

include "src/attacks/general.asm"
include "src/attacks/attack_0.asm"
