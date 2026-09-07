#include "math.h"

bool sans_physics_collision_within_box(vec24_t position, vec2_t size, vec24_t box_position, vec2_t box_size) {
    return position.x >= box_position.x
        && position.y >= box_position.y
        && position.x + size.x <= box_position.x + box_size.x
        && position.y + size.y <= box_position.y + box_size.y;
}
