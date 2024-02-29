default_character := glyph_slash
default_character_width := glyph_slash.width

header:
    db 0 ; Format Version
    db glyph_0.height ; Height
    .glyph_first := ' '
    .glyph_count := 'Z' - .glyph_first + 1
    db .glyph_count ; Glyph count
    db .glyph_first ; First glyph
    dl .widths - . ; Width table offsets
    dl .bitmaps - . ; Bitmaps offset
    db 0 ; Italics space adjust
    db 0 ; Space above
    db 0 ; Space below
    db 0 ; Weight
    db 0 ; Style field

    .widths:
        width space
        width_empty_range ' ', '/'

        width slash
        width 0
        width 1
        width 2
        width 3
        width 4
        width 5
        width 6
        width 7
        width 8
        width 9
        width_empty_range '9', 'A'

        width A
        width B
        width C
        width D
        width E
        width F
        width G
        width H
        width I
        width J
        width K
        width L
        width M
        width N
        width O
        width P
        width Q
        width R
        width S
        width T
        width U
        width V
        width W
        width X
        width Y
        width Z
    .bitmaps:
        bitmap_entry space
        bitmap_empty_range ' ', '/'

        bitmap_entry slash
        bitmap_entry 0
        bitmap_entry 1
        bitmap_entry 2
        bitmap_entry 3
        bitmap_entry 4
        bitmap_entry 5
        bitmap_entry 6
        bitmap_entry 7
        bitmap_entry 8
        bitmap_entry 9
        bitmap_empty_range '9', 'A'

        bitmap_entry A
        bitmap_entry B
        bitmap_entry C
        bitmap_entry D
        bitmap_entry E
        bitmap_entry F
        bitmap_entry G
        bitmap_entry H
        bitmap_entry I
        bitmap_entry J
        bitmap_entry K
        bitmap_entry L
        bitmap_entry M
        bitmap_entry N
        bitmap_entry O
        bitmap_entry P
        bitmap_entry Q
        bitmap_entry R
        bitmap_entry S
        bitmap_entry T
        bitmap_entry U
        bitmap_entry V
        bitmap_entry W
        bitmap_entry X
        bitmap_entry Y
        bitmap_entry Z
