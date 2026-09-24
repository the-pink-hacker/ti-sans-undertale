#include "bone.h"

#include <stdint.h>
#include <graphx.h>

#include "entity.h"
#include "vec.h"
#include "color.h"
#include "generated/sprites/attacks.h"

#define G_BOTTOM_RISE_SPEED_UP 8
#define G_BOTTOM_RISE_SPEED_DOWN 6
#define G_BOTTOM_RISE_MAX_HEIGHT 24
static sans_entity_handle_t g_bottom_rise;
static uint8_t g_bottom_rise_height = 0;
static uint8_t g_bottom_rise_frames = 0;

#define G_BOTTOM 192
#define G_LEFT 122
#define G_BONE_WIDTH SPRITE_BONE_TOP_WIDTH

// Draws a bone with a top upwards from the provided position
static void g_draw_bone_top(vec24_t position, uint8_t height) {
    gfx_TransparentSprite_NoClip(
        &sprite_bone_top,
        position.x,
        position.y - height - SPRITE_BONE_TOP_HEIGHT
    );
    gfx_FillRectangle_NoClip(
        position.x + 1,
        position.y - height,
        3,
        height
    );
}

static void g_bottom_rise_update(uint8_t id) {
    (void)id;

    switch (g_bottom_rise_frames) {
        case 0:
        case 1:
        case 2:
            g_bottom_rise_height += G_BOTTOM_RISE_SPEED_UP;
            break;
        case 39:
        case 40:
        case 41:
        case 42:
            g_bottom_rise_height -= G_BOTTOM_RISE_SPEED_DOWN;
            break;
    }

    g_bottom_rise_frames++;
}

static void g_bottom_rise_draw(uint8_t id) {
    (void)id;
    gfx_SetColor(SANS_COLOR_WHITE);
    vec24_t position = vec2(G_LEFT - 3, G_BOTTOM);

    for (uint8_t i = 0; i < 14; i++) {
        g_draw_bone_top(position, g_bottom_rise_height);
        position.x += G_BONE_WIDTH + 1;
    }
}

void sans_bone_spawn_bottom_rise(void) {
    g_bottom_rise = sans_entity_push(g_bottom_rise_update, g_bottom_rise_draw, 0);
}

void sans_bone_remove_bottom_rise(void) {
    sans_entity_remove(g_bottom_rise);
}
