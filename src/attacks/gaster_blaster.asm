gaster_blaster:
    .frames := 6
    .rotations := 20

gaster_blaster.offsets:
    repeat gaster_blaster.rotations
        dl (% - 1) * (56 * 56 + 2)
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

; Overwrites the code to save on space
; It *should* be fine
gaster_blaster.file_pointers:
    .offset_0 := 3 * 0
    .offset_1 := 3 * 1
    .offset_2 := 3 * 2
    .offset_3 := 3 * 3
    .offset_4 := 3 * 4
    .offset_5 := 3 * 5
gaster_blaster.init:
    ld ix, gaster_blaster.file_pointers

    ld bc, .mode
    push bc ; mode
        ld hl, .name_0
        push hl ; name
            call io.Open
        pop hl
    pop bc

    or a, a
    jq z, .failed

    ld c, a
    push bc
        call io.GetDataPtr
    pop bc

    ld (ix + gaster_blaster.file_pointers.offset_0), hl

    push bc
        call io.Close
    pop bc

    ld bc, .mode
    push bc ; mode
        ld hl, .name_1
        push hl ; name
            call io.Open
        pop hl
    pop bc

    or a, a
    jq z, .failed

    ld c, a
    push bc
        call io.GetDataPtr
    pop bc

    ld (ix + gaster_blaster.file_pointers.offset_1), hl

    push bc
        call io.Close
    pop bc

    ld bc, .mode
    push bc ; mode
        ld hl, .name_2
        push hl ; name
            call io.Open
        pop hl
    pop bc

    or a, a
    jq z, .failed

    ld c, a
    push bc
        call io.GetDataPtr
    pop bc

    ld (ix + gaster_blaster.file_pointers.offset_2), hl

    push bc
        call io.Close
    pop bc

    ld bc, .mode
    push bc ; mode
        ld hl, .name_3
        push hl ; name
            call io.Open
        pop hl
    pop bc

    or a, a
    jq z, .failed

    ld c, a
    push bc
        call io.GetDataPtr
    pop bc

    ld (ix + gaster_blaster.file_pointers.offset_3), hl

    push bc
        call io.Close
    pop bc

    ld bc, .mode
    push bc ; mode
        ld hl, .name_4
        push hl ; name
            call io.Open
        pop hl
    pop bc

    or a, a
    jq z, .failed

    ld c, a
    push bc
        call io.GetDataPtr
    pop bc

    ld (ix + gaster_blaster.file_pointers.offset_4), hl

    push bc
        call io.Close
    pop bc

    ld bc, .mode
    push bc ; mode
        ld hl, .name_5
        push hl ; name
            call io.Open
        pop hl
    pop bc

    or a, a
    jq z, .failed

    ld c, a
    push bc
        call io.GetDataPtr
    pop bc

    ld (ix + gaster_blaster.file_pointers.offset_5), hl

    push bc
        call io.Close
    pop bc

    ret

    .name_0:
        db "SANSGB0", 0
    .name_1:
        db "SANSGB1", 0
    .name_2:
        db "SANSGB2", 0
    .name_3:
        db "SANSGB3", 0
    .name_4:
        db "SANSGB4", 0
    .name_5:
        db "SANSGB5", 0
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
