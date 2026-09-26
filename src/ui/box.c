#include "box.h"

#include <graphx.h>

#define G_THICKNESS 3

#define G_POSITION_DEFAULT_X SANS_UI_BOX_DEFAULT_LEFT
#define G_POSITION_DEFAULT_Y 114
#define G_SIZE_DEFAULT_X SANS_UI_BOX_DEFAULT_WIDTH
#define G_SIZE_DEFAULT_Y SANS_UI_BOX_DEFAULT_HEIGHT

#define G_POSITION_WIDE_X 18
#define G_POSITION_WIDE_Y (G_POSITION_DEFAULT_Y + (G_SIZE_DEFAULT_Y - G_SIZE_WIDE_Y))
#define G_SIZE_WIDE_X 284
#define G_SIZE_WIDE_Y 60

// How fast the box changes in size
#define G_SPEED 10

static vec24_t g_position = vec2(0, 0);
static vec24_t g_size = vec2(0, 0);
static vec24_t g_target_position = vec2(0, 0);
static vec24_t g_target_size = vec2(0, 0);
static bool g_transition = false;

static bool g_lerp_24(uint24_t *original, uint24_t target, uint8_t speed) {
    int24_t diff = target - *original;

    if (diff > speed) {
        *original += speed;
    } else if (diff < -speed) {
        *original -= speed;
    } else {
        *original += diff;
        return false;
    }

    return true;
}

static bool g_lerp_8(uint8_t *original, uint8_t target) {
    int8_t diff = target - *original;

    if (diff > G_SPEED) {
        *original += G_SPEED;
    } else if (diff < -G_SPEED) {
        *original -= G_SPEED;
    } else {
        *original += diff;
        return false;
    }

    return true;
}

void sans_ui_box_update(void) {
    if (!g_transition) {
        return;
    }

    bool changed = false;

    changed |= g_lerp_24(&g_position.x, g_target_position.x, G_SPEED);
    changed |= g_lerp_8(&g_position.y, g_target_position.y);
    changed |= g_lerp_24(&g_size.x, g_target_size.x, G_SPEED * 2);
    changed |= g_lerp_8(&g_size.y, g_target_size.y);

    if (!changed) {
        g_transition = false;
    }
}

void sans_ui_box_draw(void) {
    // Checks if box is disabled
    if (g_size.x == 0 && g_size.y == 0) {
        return;
    }

    vec24_t position = g_position;
    vec24_t size = g_size;

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

vec24_t sans_ui_box_get_size(void) {
    return g_size;
}

void sans_ui_box_set_size_default(void) {
    g_position.x = G_POSITION_DEFAULT_X;
    g_position.y = G_POSITION_DEFAULT_Y;
    g_size.x = G_SIZE_DEFAULT_X;
    g_size.y = G_SIZE_DEFAULT_Y;
}

void sans_ui_box_transition_wide(void) {
    g_target_position.x = G_POSITION_WIDE_X;
    g_target_position.y = G_POSITION_WIDE_Y;
    g_target_size.x = G_SIZE_WIDE_X;
    g_target_size.y = G_SIZE_WIDE_Y;
    g_transition = true;
}

void sans_ui_box_transition_default(void) {
    g_target_position.x = G_POSITION_DEFAULT_X;
    g_target_position.y = G_POSITION_DEFAULT_Y;
    g_target_size.x = G_SIZE_DEFAULT_X;
    g_target_size.y = G_SIZE_DEFAULT_Y;
    g_transition = true;
}

void sans_ui_box_disable(void) {
    g_size.x = 0;
    g_size.y = 0;
}
