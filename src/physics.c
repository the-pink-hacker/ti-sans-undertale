#include "physics.h"

#include <string.h>

static sans_physics_collider_id_t g_next_id = {
    .g_id = 0,
};

static sans_physics_list_t g_list = {
    .count = 0,
};

static uint24_t g_clamp_24(uint24_t x, uint24_t min, uint24_t max) {
    if (x < min) {
        return min;
    } else if (x > max) {
        return max;
    } else {
        return x;
    }
}

static uint8_t g_clamp_8(uint8_t x, uint8_t min, uint8_t max) {
    if (x < min) {
        return min;
    } else if (x > max) {
        return max;
    } else {
        return x;
    }
}

void sans_physics_clamp_within_box(vec24_t *position, vec2_t size, vec24_t box_position, vec24_t box_size, bool *grounded) {
    position->x = g_clamp_24(position->x, box_position.x, box_position.x + box_size.x - size.x);
    uint8_t y = position->y;
    uint8_t y_max = box_position.y + box_size.y - size.y;
    if (!*grounded && y >= y_max) {
        *grounded = true;
    }
    position->y = g_clamp_8(y, box_position.y, y_max);
}

sans_physics_collider_id_t sans_physics_list_push_y_down(
    uint8_t *y
) {
    sans_physics_list_element_t *element = &g_list.elements[g_list.count];
    element->damage = SANS_PHYSCIS_DAMAGE_MISC;
    element->shape = SANS_PHYSCIS_SHAPE_Y_DOWN;
    element->value.plane_horizontal.y = y;
    g_list.count++;
    element->id = g_next_id;
    g_next_id.g_id++;
    return element->id;
}

sans_physics_collider_id_t sans_physics_list_push_column_gap(
    vec24i_t *position,
    vec2_t size
) {
    sans_physics_list_element_t *element = &g_list.elements[g_list.count];
    element->damage = SANS_PHYSCIS_DAMAGE_MISC;
    element->shape = SANS_PHYSCIS_SHAPE_COLUMN_GAP;
    element->value.transform.position = position;
    element->value.transform.size = size;
    g_list.count++;
    element->id = g_next_id;
    g_next_id.g_id++;
    return element->id;
}

sans_physics_list_t *sans_physics_get_list(void) {
    return &g_list;
}

// Swap remove
void sans_physics_list_remove(sans_physics_collider_id_t id) {
    for (uint8_t i = 0; i < g_list.count; i++) {
        sans_physics_list_element_t *element = &g_list.elements[i];

        if (element->id.g_id != id.g_id) {
            continue;
        }

        g_list.count--;

        if (g_list.count == 0 || i == g_list.count) {
            // Element was at end or there are no more elements; no shifting needed
            break;
        }

        memcpy(
            element,
            &g_list.elements[g_list.count],
            sizeof(sans_physics_list_element_t)
        );

        break;
    }
}

void sans_physics_list_reset(void) {
    g_list.count = 0;
}
