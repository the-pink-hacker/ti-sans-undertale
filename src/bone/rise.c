#include "rise.h"

#include "../bone.h"
#include "../entity.h"
#include "../physics.h"
#include "../ui/box.h"
#include "../generated/sprites/attacks.h"

#define G_SPEED_UP 8
#define G_SPEED_DOWN 6
#define G_MAX_HEIGHT 24
static sans_entity_handle_t g_entity;
static uint8_t g_height = 0;
static uint8_t g_collider_y;

#define G_BOTTOM SANS_UI_BOX_BOTTOM
#define G_LEFT SANS_UI_BOX_DEFAULT_LEFT
#define G_BONE_WIDTH SPRITE_BONE_TOP_WIDTH


static void g_update_collider(void) {
    g_collider_y = G_BOTTOM - g_height - SPRITE_BONE_TOP_HEIGHT;
}

static void g_update(uint8_t id) {
    (void)id;
    static uint8_t frames = 0;
    static uint8_t collider_id;

    switch (frames) {
        case 0:
            // Also move the bones on frame zero
            collider_id = sans_physics_list_push_y_down(&g_collider_y);

            // Continue here
        case 1:
        case 2:
            g_height += G_SPEED_UP;
            g_update_collider();
            break;
        case 42:
            // Move down and remove collider
            // Doesn't matter because the player cannot collide anyways
            sans_physics_list_remove(collider_id);

            // Continue here
        case 39:
        case 40:
        case 41:
            g_height -= G_SPEED_DOWN;
            g_update_collider();
            break;
    }

    frames++;
}

static void g_draw(uint8_t id) {
    (void)id;
    vec24_t position = vec2(G_LEFT - 3, G_BOTTOM);

    for (uint8_t i = 0; i < 14; i++) {
        sans_bone_draw_top(position, g_height);
        position.x += G_BONE_WIDTH + 1;
    }
}

void sans_bone_rise_spawn_bottom(void) {
    g_entity = sans_entity_push(g_update, g_draw, 0);
}

void sans_bone_rise_remove_bottom(void) {
    sans_entity_remove(g_entity);
}
