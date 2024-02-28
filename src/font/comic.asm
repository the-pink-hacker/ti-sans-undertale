header:
    db 0 ; Format Version
    db glyph_a.height ; Height
    .glyph_first := '!'
    .glyph_count := 'z' - .glyph_first + 1
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
        width exclamation_mark
        width_empty_range '!', "'"

        width apostrophe
        width_empty_range "'", ","

        width comma
        width_empty_range ',', "."

        width period
        width_empty_range '.', "?"

        width question_mark
        width_empty_range '?', "A"

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
        width_empty_range 'Z', "a"

        width a
        width b
        width c
        width d
        width e
        width f
        width g
        width h
        width i
        width j
        width k
        width l
        width m
        width n
        width o
        width p
        width q
        width r
        width s
        width t
        width u
        width v
        width w
        width x
        width y
        width z
    .bitmaps:
        bitmap_entry exclamation_mark
        bitmap_empty_range '!', "'"

        bitmap_entry apostrophe
        bitmap_empty_range "'", ','

        bitmap_entry comma
        bitmap_empty_range ',', '.'

        bitmap_entry period
        bitmap_empty_range '.', '?'

        bitmap_entry question_mark
        bitmap_empty_range '?', 'A'

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
        bitmap_empty_range 'Z', 'a'

        bitmap_entry a
        bitmap_entry b
        bitmap_entry c
        bitmap_entry d
        bitmap_entry e
        bitmap_entry f
        bitmap_entry g
        bitmap_entry h
        bitmap_entry i
        bitmap_entry j
        bitmap_entry k
        bitmap_entry l
        bitmap_entry m
        bitmap_entry n
        bitmap_entry o
        bitmap_entry p
        bitmap_entry q
        bitmap_entry r
        bitmap_entry s
        bitmap_entry t
        bitmap_entry u
        bitmap_entry v
        bitmap_entry w
        bitmap_entry x
        bitmap_entry y
        bitmap_entry z
