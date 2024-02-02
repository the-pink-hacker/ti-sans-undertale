include "src/player/blue.asm"
include "src/player/red.asm"

player.heart:
    .location_y:
        db ti.lcdHeight - 64
    .location_x:
        dl ti.lcdWidth / 2
