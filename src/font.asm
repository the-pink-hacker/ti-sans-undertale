include "include/ez80.inc"
include "include/tiformat.inc"
format ti archived appvar "SANSFNT"

macro width glyph
    db glyph_#glyph.width
end macro

macro width_empty_range lower, upper
    repeat upper - lower - 1
        dw default_character - . - 2
    end repeat
end macro

macro bitmap_entry glyph
    dw glyph_#glyph - . - 2
end macro

macro bitmap_empty_range lower, upper
    repeat upper - lower - 1
        dw default_character - . - 2
    end repeat
end macro

pack:
    db "FONTPACK" ; header
    dl .metadata - . ; metadata
    db 3 ; font_count
    dl comic.header - pack
    dl hud.header - pack
    dl comic.header - pack

    .metadata:
        dw .metadata.length ; length
        dw 0 ; font_family_name
        dw 0 ; font_author
        dw 0 ; font_pseudocopyright
        dw 0 ; font_description
        dw 0 ; font_version
        dw 0 ; font_code_page
    .metadata.length := $ - .

namespace comic
    include "src/font/comic.asm"
    include "src/generated/sprites/font_comic.asm"
end namespace

namespace hud
    include "src/font/hud.asm"
    include "src/generated/sprites/font_hud.asm"
end namespace
