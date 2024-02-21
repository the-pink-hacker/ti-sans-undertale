font.pointers:
font.init:
    ld bc, gaster_blaster.init.mode
    push bc ; mode
        ld hl, .name
        push hl ; name
            call io.Open
        pop hl
    pop bc

    or a, a
    jq z, gaster_blaster.init.failed

    ld c, a
    push bc ; handel
        call io.GetDataPtr

        ld (font.pointers), hl

        call io.Close
    pop bc

    ld l, 0
    push hl ; flags
        ld hl, (font.pointers)
        push hl ; font
            call font.SetFont
        pop hl
    pop hl

    or a, a
    jq z, sans_undertale.exit_safe

    call font.SetWindowFullScreen

    ld l, TRUE
    push hl ; transparency
        call font.SetTransparency
    pop hl

    ld l, 0
    push hl ; newline_options
        call font.SetNewlineOptions
    pop hl

    ld hl, $FF
    push hl ; color
        call font.SetForegroundColor
    pop hl

    ret

    .name:
        db "SANSFNT", 0

font.draw:
    call font.HomeUp
    ;call font.ClearWindow

    ld hl, .text
    push hl ; text
        call font.DrawString
    pop hl

    ret

    .text:
        db "SANS UNDERTALE!? Cool beans...", 0
