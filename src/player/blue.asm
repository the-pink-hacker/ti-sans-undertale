player.blue.update:
; ix = flags
    ret

player.blue.draw:
; ix = flags
    ld hl, player.heart.location_y
    ld e, (hl)
    push de ; y
        inc hl
        ld de, (hl)
        push de ; x
            ld hl, sprites.heart_blue
            push hl ; sprite
                call gfx.Sprite_NoClip
            pop hl
        pop hl
    pop hl

    ret
