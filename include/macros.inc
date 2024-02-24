macro libload_header name, version
    db $C0, name, 0, version
end macro

macro libload_func name, offset
    name:
        jp 3 * offset
end macro

macro label_with_offset name
    name.offset := $ - .
    name:
end macro

macro set_color color
    ld l, color
    push hl ; color
        call gfx.SetColor
    pop hl
end macro
