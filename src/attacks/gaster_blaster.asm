; The file handle to the gaster blaster sprites
gaster_blaster.file:
    db 0

gaster_blaster.init:
    ld hl, .mode
    push hl ; mode
        ld hl, .name
        push hl ; name
            call io.Open
        pop hl
    pop hl

    or a, a
    jp z, .failed

    ld (gaster_blaster.file), a

    ld c, a
    push bc
        call io.GetDataPtr
    pop bc

    call ti.PutS
    call ti.GetKey

    ret

    .name:
        db "SANSGB0", 0
    .mode:
        db "r", 0

    .failed:
        ld hl, .failed.text
        call ti.PutS
        call ti.GetKey

        jp sans_undertale.exit_safe
    .failed.text:
        db "Couldn't find asset: GB0", 0

gaster_blaster.exit:
    ld hl, gaster_blaster.file
    ld l, (hl)
    push hl
        call io.Close
    pop hl
    ret
