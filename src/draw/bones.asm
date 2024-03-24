bone_thickness := 3

draw.bone_horizontal:
; Arguments:
;   iy = *bone
    .bone.x := 0
    .bone.y := 3
    .bone.height := 4

    ld hl, 0
    ld l, (iy + .bone.height)

    push iy

        push hl
            ld l, (iy + .bone.y)
            push hl ; y
                ld hl, (iy + .bone.x)
                push hl ; x
                    ld hl, sprites.bone_top
                    push hl ; sprite
                        call gfx.TransparentSprite
                    pop hl
                pop bc
            pop hl
        pop de
        
        inc hl
        inc hl
        inc hl
        
        push de, de ; height
                    ; Pushed twice to prevent value from being destoryed.
            ld e, bone_thickness
            push de ; width
                push hl ; y
                    inc bc
                    push bc ; x
                        call gfx.FillRectangle
                    pop bc
                pop hl
            pop de
        pop de, de
        
        add hl, de
        
        push hl ; y
            dec bc
            push bc ; x
                ld hl, sprites.bone_bottom
                push hl ; sprite
                    call gfx.TransparentSprite
                pop hl
            pop hl
        pop hl

    pop iy

    ret
