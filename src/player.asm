include "src/player/blue.asm"
include "src/player/red.asm"

player.heart:
    label_with_offset .location_y
        db ti.lcdHeight - 96
    label_with_offset .location_x
        dl (ti.lcdWidth - 8) / 2
    label_with_offset .health_string
        db "00/92", 0
