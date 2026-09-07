#include "physics.h"

#include "stdint.h"

static uint24_t _clamp_24(uint24_t x, uint24_t min, uint24_t max) {
    if (x < min) {
        return min;
    } else if (x > max) {
        return max;
    } else {
        return x;
    }
}

static uint8_t _clamp_8(uint8_t x, uint8_t min, uint8_t max) {
    if (x < min) {
        return min;
    } else if (x > max) {
        return max;
    } else {
        return x;
    }
}

void sans_physics_clamp_within_box(vec24_t *position, vec2_t size, vec24_t box_position, vec2_t box_size) {
    position->x = _clamp_24(position->x, box_position.x, box_position.x + box_size.x - size.x);
    position->y = _clamp_8(position->y, box_position.y, box_position.y + box_size.y - size.y);
}
