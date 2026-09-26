#include "clip.h"

#include <graphx.h>

#include "ui/box.h"

void sans_clip_box(void) {
    vec24_t box_position = sans_ui_box_position();
    vec24_t box_size = sans_ui_box_get_size();
    gfx_SetClipRegion(
        box_position.x,
        box_position.y,
        box_position.x + box_size.x,
        box_position.y + box_size.y
    );
}
