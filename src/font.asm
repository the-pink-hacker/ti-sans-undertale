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

    ld l, ' '
    push hl ; character
        call font.SetAlternateStopCode
    pop hl

    ret

    .name:
        db "SANSFNT", 0

font.current_character:
    dl 0

font.draw:
    call font.HomeUp
    ld hl, font.text
    jp .string_first_iteration

    .string_space:
        ld l, 0
        push hl ; y
            ld hl, 8
            push hl ; x
                call font.ShiftCursorPosition
            pop hl
        pop hl
    .string:
        ld hl, (font.current_character)
    .string_first_iteration:
        push hl ; text
            call font.DrawString ; hl = x
        pop bc
        
        call font.GetLastCharacterRead
        inc hl
        ld (font.current_character), hl

        xor a, a
        cp a, (hl)

        ret z
        
        push hl ; text
            call font.GetStringWidth
        pop bc

        call font.GetCursorX
        
        add hl, bc ; x + width 
        
        ld de, ti.lcdWidth - 64 ; TODO: Some words wrap too early/late?
        ex de, hl
        sbc hl, de ; total_width - (x + width)
        jq nc, .string_space

        ; Word wrap
        call font.Newline

        jp .string

font.text:
        db "According to all known laws of aviation, there is no way a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee, of course, flies anyway because bees don't care what humans think is impossible. Yellow, black. Yellow, black. Yellow, black. Yellow, black. Ooh, black and yellow! Let's shake it up a little. Barry! Breakfast is ready! Coming! Hang on a second.", 0
