NULL := 0

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

macro display_decimal number
    repeat 1 index: number
        display `index
    end repeat
end macro

macro string text
    db text, 0
end macro

macro gaster_blaster_blast: original_rotation, x, y
    radius = 10
    length = 325
    quarter = PI / 2.0
    rotation = TAU - original_rotation
    side_rotation = rotation - quarter
    side_alt_rotation = rotation + quarter

    cos side_rotation, TRIG_ITERATIONS
    xa0 = x + trunc (result * radius)
    sin side_rotation, TRIG_ITERATIONS
    ya0 = y + trunc (result * radius)

    cos rotation, TRIG_ITERATIONS
    x_end = x + trunc (result * length)
    sin rotation, TRIG_ITERATIONS
    y_end = y + trunc (result * length)

    cos side_rotation, TRIG_ITERATIONS
    xa1 = x_end + trunc (result * radius)
    sin side_rotation, TRIG_ITERATIONS
    ya1 = y_end + trunc (result * radius)

    cos side_alt_rotation, TRIG_ITERATIONS
    xa2 = x_end + trunc (result * radius)
    sin side_alt_rotation, TRIG_ITERATIONS
    ya2 = y_end + trunc (result * radius)

    xb0 = xa0
    yb0 = ya0
    
    cos side_alt_rotation, TRIG_ITERATIONS
    xb1 = x + trunc (result * radius)
    sin side_alt_rotation, TRIG_ITERATIONS
    yb1 = y + trunc (result * radius)

    xb2 = xa2
    yb2 = ya2
end macro
