default_character := glyph_slash

header:
    db 0 ; Format Version
    db glyph_0.height ; Height
    .glyph_first := '/'
    .glyph_count := '9' - .glyph_first + 1
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

    .bitmaps:
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
