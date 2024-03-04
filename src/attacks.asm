macro attack_step label, seconds
    dl trunc (seconds * target_fps)
    dl label
end macro

attack_step_size := 6

attack.advance_step:
    ld iy, (ix + flags.current_attack.offset)
    ld bc, attack_step_size
    add iy, bc ; Advance to next step
    ld (ix + flags.current_attack.offset), iy

    ld bc, (iy)
    ld hl, (ix + flags.frame_counter.offset)
    add hl, bc ; Advance step counter
    ld (ix + flags.frame_counter_attack_step_end.offset), hl

    inc iy
    inc iy
    inc iy ; *step

    ld hl, (iy) ; step
    ld (attack.step), hl
    ret

attack.step := $ + 1
attack.run_step:
    jp 0

test:
    db bones_y
    dl bones_x

example_attack:
    attack_step .step_0, 1
    attack_step .step_1, 1
    attack_step .step_2, 1
    attack_step .step_3, 1
    attack_step .step_0, 1
    attack_step .step_1, 1
    attack_step .step_2, 1
    attack_step .step_3, 1
    attack_step .step_0, 1
    attack_step .step_1, 1
    attack_step .step_2, 1
    attack_step .step_3, 1
    attack_step .step_0, 1
    attack_step .step_1, 1
    attack_step .step_2, 1
    attack_step .step_3, 1
    attack_step .step_4, 0

    .step_0:
        ld hl, (test + 1)
        inc hl
        ld (test + 1), hl
        ret

    .step_1:
        ld hl, test
        dec (hl)
        ret

    .step_2:
        ld hl, (test + 1)
        dec hl
        ld (test + 1), hl
        ret

    .step_3:
        ld hl, test
        inc (hl)
        ret

    .step_4:
        pop hl
        jp sans_undertale.exit

include "src/attacks/gaster_blaster.asm"
