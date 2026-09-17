#include "box.h"

#include <graphx.h>

#define G_THICKNESS 3

static vec24_t g_position = vec2(0, 0);
static vec2_t g_size = vec2(0, 0);

void sans_ui_box_draw(void) {
    // Checks if box is disabled
    if (g_size.x == 0 && g_size.y == 0) {
        return;
    }

    vec24_t position = g_position;
    vec2_t size = g_size;

    for (uint8_t i = 0; i < G_THICKNESS; i++) {
        position.x--;
        position.y--;
        size.x += 2;
        size.y += 2;

        gfx_Rectangle_NoClip(position.x, position.y, size.x, size.y);
    }
}

vec24_t sans_ui_box_position(void) {
    return g_position;
}

vec2_t sans_ui_box_get_size(void) {
    return g_size;
}

void sans_ui_box_set_size_default(void) {
    g_position.x = 120;
    g_position.y = 112;
    g_size.x = 80;
    g_size.y = 80;
}

void sans_ui_box_disable(void) {
    g_size.x = 0;
    g_size.y = 0;
}
