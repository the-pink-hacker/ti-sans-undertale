text.hud:
    .y := 203
    .character.x := 20
    .character:
        string "CHARA"
    .level.x := 78
    .level:
        string "LV 19 HP"
    .health.x := 185
    .health:
        db "KR "
    .health.number:
        string "00/92"

text.pointers:
    .comic := $
    .hud := $ + 3
    .dialog := $ + 6
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

        ld ix, text.pointers

        ld c, 0
        push bc ; index
            push hl ; *pack
                call font.GetFontByIndexRaw
                ld (ix), hl
            pop hl
        pop bc

        inc c
        push bc ; index
            push hl ; *pack
                call font.GetFontByIndexRaw
                ld (ix + 3), hl
            pop hl
        pop bc

        inc c
        push bc ; index
            push hl ; *pack
                call font.GetFontByIndexRaw
                ld (ix + 6), hl
            pop hl
        pop bc
    pop bc

    call io.Close

    ld l, 0
    push hl ; flags
        ld hl, (text.pointers.hud)
        push hl ; font
            call font.SetFont
        pop hl
    pop hl

    or a, a
    jq z, sans_undertale.exit_safe

    ld l, 5
    push hl ; height
        ld hl, ti.lcdWidth
        push hl ; width
            ld l, text.hud.y
            push hl ; y
                ld hl, text.hud.character.x
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
