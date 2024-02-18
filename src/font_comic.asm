include "include/ez80.inc"
include "include/tiformat.inc"
format ti archived appvar "SANSFNTC"

macro bitmap_entry glyph
    dw .glyph_#glyph - header - 2
end macro

header:
    db 0 ; Format Version
    db 8 ; Height
    .glyph_first := '!'
    .glyph_count := 'z' - .glyph_first
    db .glyph_count ; Glyph count
    db .glyph_first ; First glyph
    dl .widths - . ; Width table offsets
    dl .bitmaps - . ; Bitmaps offset
    db 0 ; Italics space adjust
    db 0 ; Space above
    db 0 ; Space below
    db 0 ; Weight
    db 0 ; Style field
    db 0 ; Capital height
    db 0 ; Lowercase x height
    db 0 ; Baseline height

    .widths:
        repeat .glyph_count
            db 0
        end repeat
    .bitmaps:
        repeat .glyph_count
            dw 0
        end repeat
