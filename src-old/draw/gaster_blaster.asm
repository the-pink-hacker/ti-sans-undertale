gaster_blaster:
    .frames := 6
    .rotations := 20
    .circle_radius := 50
    .size := 56
    .center_x := box_x + (box_size - .size) / 2 + box_thickness
    .center_y := box_y + (box_size - .size) / 2 + box_thickness
    .offsets:
        repeat .rotations, index: 0
            dl index * (.size * .size + 2)
        end repeat
    .locations:
        repeat .rotations, index: 0
            ; Y
            radians = ((%% - index) * TAU) / .rotations
            cos radians
            db .center_y - trunc (result * .circle_radius)
            ; X
            sin radians
            dl .center_x + trunc (result * .circle_radius)
        end repeat

gaster_blaster.get_sprite:
; Arguments:
    .frame    := 3 ; u8
    .rotation := 4 ; u8
; Return:
;   hl: *sprite
    ld iy, 0
    add iy, sp

    ld h, (iy + .rotation)
    ld l, 3
    mlt hl ; rotation * 3

    ld de, gaster_blaster.offsets
    add hl, de
    ld hl, (hl) ; gaster_blaster.offsets[rotation]

    ld b, (iy + .frame)
    ld c, 3
    mlt bc ; frame * 3

    ld de, gaster_blaster.file_pointers
    ex de, hl
    add hl, bc
    ld hl, (hl) ; gaster_blaster.file_pointers[frame]

    add hl, de ; *sprite
    ret

gaster_blaster.get_location:
; Arguments:
;   c: rotation u8 
; Return:
;   de: x u24
;   c:  y u8
; Destroyes:
;   bc
;   hl
    ld b, 4
    mlt bc ; 4 * rotation

    ld hl, gaster_blaster.locations
    add hl, bc ; *gaster_blaster.locations[rotation]
    
    ld c, (hl) ; y
    inc hl ; *x
    ld de, (hl) ; x
    ret

; Overwrites the code to save on space
; It *should* be fine
gaster_blaster.file_pointers:
    repeat gaster_blaster.frames, index: 0
        .offset_#index := 3 * index
    end repeat

gaster_blaster.init:
    ld ix, gaster_blaster.file_pointers

    repeat gaster_blaster.frames, index: 0
        ld bc, .mode
        push bc ; mode
            ld hl, .name_#index
            push hl ; name
                call io.Open
            pop hl
        pop bc
        
        or a, a
        jq z, .failed
        
        ld c, a
        push bc
            call io.GetDataPtr
        
            ld (ix + gaster_blaster.file_pointers.offset_#index), hl
        
            call io.Close
        pop bc
    end repeat

    ret

    repeat gaster_blaster.frames, index: 0
        .name_#index:
            db "SANSGB", `index, 0
    end repeat

    .mode:
        db "r", 0

    .failed:
        push hl
        ld hl, .failed.text
        call ti.PutS
        pop hl
        call ti.PutS
        call ti.GetKey

        jp sans_undertale.exit_safe
    .failed.text:
        db "Couldn't find asset: ", 0

gaster_blaster.draw_blast_vertical:
; Arguments:
;   hl: x
;   a: thickness
    ld de, ti.lcdHeight
    assert ti.lcdHeight < 256 ; d = 0
    push de ; height
        ld e, a
        push de ; width
            ld e, d ; de = 0
            push de ; y
                push hl ; x
                    call gfx.FillRectangle_NoClip
                pop hl
            pop de
        pop de
    pop de

    ret

gaster_blaster.draw_blast_horizontal:
; Arguments:
;   a: y
;   l: thickness
    push hl ; height
        ld hl, ti.lcdWidth
        push hl ; width
            ld l, a
            push hl ; y
                ld hl, 0
                push hl ; x
                    call gfx.FillRectangle_NoClip
                pop hl
            pop hl
        pop hl
    pop hl

    ret
