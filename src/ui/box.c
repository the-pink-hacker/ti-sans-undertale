#include "box.h"

#include <graphx.h>

#define _THICKNESS 3

static vec24_t _position = vec2(0, 0);
static vec2_t _size = vec2(0, 0);

void sans_ui_box_draw(void) {
    // Checks if box is disabled
    if (_size.x == 0 && _size.y == 0) {
        return;
    }

    vec24_t position = _position;
    vec2_t size = _size;

    for (uint8_t i = 0; i < _THICKNESS; i++) {
        position.x--;
        position.y--;
        size.x += 2;
        size.y += 2;

        gfx_Rectangle_NoClip(position.x, position.y, size.x, size.y);
    }
}

vec24_t sans_ui_box_position(void) {
    return _position;
}

vec2_t sans_ui_box_get_size(void) {
    return _size;
}

void sans_ui_box_set_size_default(void) {
    _position.x = 120;
    _position.y = 112;
    _size.x = 80;
    _size.y = 80;
}

void sans_ui_box_disable(void) {
    _size.x = 0;
    _size.y = 0;
}
