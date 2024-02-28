health_text:
    .number:
    db "00/92", 0

text.pointers:
text.init:
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

        ld (text.pointers), hl

        call io.Close
    pop bc

    ld l, 0
    push hl ; flags
        ld hl, (text.pointers)
        push hl ; font
            call font.SetFont
        pop hl
    pop hl

    or a, a
    jq z, sans_undertale.exit_safe

    ld l, ti.lcdHeight - health_text_y
    push hl ; height
        ld hl, ti.lcdWidth - health_text_x
        push hl ; width
            ld l, health_text_y
            push hl ; y
                ld hl, health_text_x
                push hl ; x
                    call font.SetWindow
                pop hl
            pop hl
        pop hl
    pop hl

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

    ;ld l, ' '
    ;push hl ; character
    ;    call font.SetAlternateStopCode
    ;pop hl

    ret

    .name:
        db "SANSFNT", 0

text.current_character:
    dl 0

text.draw:
    call font.HomeUp
    ld hl, 0
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
        ld hl, (text.current_character)
    .string_first_iteration:
        push hl ; text
            call font.DrawString ; hl = x
        pop bc
        
        call font.GetLastCharacterRead
        inc hl
        ld (text.current_character), hl

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
