entity_buffer:
    .start := ti.pixelShadow2
    .size := 8_400
    .end := entity_buffer.start + entity_buffer.size
    
    .bones := entity_buffer.start + 128
    .bones.end := .bones + attack.wave_bones_table.size

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
        ld iy, entity_buffer.start
    .update_step := $ + 1
        ld hl, NULL ; SMC: will be changed to current step.
        ld de, NULL
        or a, a ; Reset carry.
        adc hl, de ; Has to be an adc since it affects the zero flag.
        ret z ; Return if null pointer.
        jp (hl)

    .run_draw_step:
        ld iy, entity_buffer.start
    .draw_step := $ + 1
        ld hl, NULL ; SMC: will be changed to current step.
        ld de, NULL
        or a, a ; Reset carry.
        adc hl, de ; Has to be an adc since it affects the zero flag.
        ret z ; Return if null pointer.
        jp (hl)

include "src/attacks/general.asm"
include "src/attacks/attack_0.asm"
include "src/attacks/gaster_blaster.asm"
