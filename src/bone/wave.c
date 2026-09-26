#include "wave.h"

#include "../bone.h"
#include "../entity.h"
#include "../clip.h"
#include "../ui/box.h"
#include "../generated/sprites/attacks.h"

#define G_GAP_X 7
#define G_GAP_Y 20
#define G_SPEED 5
#define G_BONE_ENDS (SPRITE_BONE_TOP_HEIGHT * 2)

static sans_entity_handle_t g_entity;
static int24_t g_x = SANS_UI_BOX_DEFAULT_LEFT - SPRITE_BONE_TOP_WIDTH + 1;

static void g_update(uint8_t id) {
    (void)id;
    g_x += G_SPEED;
}

static void g_draw(uint8_t id) {
    (void)id;

    sans_clip_box();

    int24_t x = g_x;

    for (uint8_t i = 0; i < 20; i++) {
        uint8_t height = 40 - i;
        vec24i_t position = vec2(x, SANS_UI_BOX_BOTTOM);
        sans_bone_draw_clip(position, height);

        uint8_t total_height = G_BONE_ENDS + G_GAP_Y + height;
        position.y -= total_height;
        height = SANS_UI_BOX_DEFAULT_HEIGHT - G_BONE_ENDS - total_height;

        sans_bone_draw_clip(position, height);
        x -= SPRITE_BONE_TOP_WIDTH + G_GAP_X;
    }
}

void sans_bone_wave_spawn(void) {
    g_entity = sans_entity_push(g_update, g_draw, 0);
}

void sans_bone_wave_remove(void) {
    sans_entity_remove(g_entity);
}
