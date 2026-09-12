#include "attack_box.h"

#include <graphx.h>

#include "color.h"

#define _attack_box_thickness 3

static vec24_t _position = {
    .x = 120,
    .y = 112,
};

static vec2_t _size = {
    .x = 80,
    .y = 80,
};

void sans_attack_box_update(void) {}

void sans_attack_box_draw(void) {
    gfx_SetColor(WHITE);

    vec24_t position = _position;
    vec2_t size = _size;

    for (uint8_t i = 0; i < _attack_box_thickness; i++) {
        position.x--;
        position.y--;
        size.x += 2;
        size.y += 2;

        gfx_Rectangle_NoClip(position.x, position.y, size.x, size.y);
    }
}

vec24_t sans_attack_box_position(void) {
    return _position;
}

vec2_t sans_attack_box_size(void) {
    return _size;
}
