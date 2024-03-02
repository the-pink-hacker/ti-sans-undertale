include "src/player/blue.asm"
include "src/player/red.asm"

player.heart:
    label_with_offset .location_y
        db box_y + sprites.heart_red.height + 8
    label_with_offset .location_x
        dl box_x + (box_size - sprites.heart_red.width) / 2
    label_with_offset .health_string
        db "XX/92", 0
