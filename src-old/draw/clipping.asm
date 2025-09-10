draw.set_clip_region_box:
    ld hl, box_y + box_size - box_thickness
    push hl ; y_max
        ld l, box_x + box_size - box_thickness
        assert box_x + box_size - box_thickness <= 255
        push hl ; x_max
            ld l, box_y + box_thickness
            push hl ; y_min
                ld l, box_x + box_thickness
                assert box_x + box_thickness <= 255
                push hl ; x_min
                    call gfx.SetClipRegion
                pop hl
            pop hl
        pop hl
    pop hl

    ret

draw.set_clip_region_screen:
; iy = unaffected
    push iy
        ld bc, ti.lcdHeight
        assert ti.lcdHeight <= 255
        push bc ; y_max
            ld hl, ti.lcdWidth
            push hl ; x_max
                ld c, 0
                push bc ; y_min
                    push bc ; x_min
                        call gfx.SetClipRegion
                    pop hl
                pop hl
            pop hl
        pop hl
    pop iy

    ret
