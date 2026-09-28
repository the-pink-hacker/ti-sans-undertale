#include "wave.h"

#include "../bone.h"
#include "../entity.h"
#include "../clip.h"
#include "../physics.h"
#include "../ui/box.h"
#include "../generated/sprites/attacks.h"
#include "../generated/lookup/bone_wave.h"

#define G_COUNT 20
#define G_GAP_X 7
#define G_GAP_Y 20
#define G_SPEED 6
#define G_BONE_ENDS (SPRITE_BONE_TOP_HEIGHT * 2)
#define G_X (SANS_UI_BOX_DEFAULT_LEFT - SPRITE_BONE_TOP_WIDTH + 1)

static sans_entity_handle_t g_entity;
static sans_physics_collider_id_t *g_colliders;
static vec24i_t *g_positions;

void sans_bone_wave_init(void) {
    // TODO: Handle malloc error
    g_positions = (vec24i_t *)malloc(sizeof(vec24i_t) * G_COUNT);

    int24_t x = G_X;

    for (uint8_t i = 0; i < G_COUNT; i++) {
        vec24i_t *position = &g_positions[i];
        position->x = x;
        uint8_t height = SANS_LOOKUP_BONE_RISE_TABLE[i];
        position->y = SANS_UI_BOX_DEFAULT_TOP + height + G_BONE_ENDS;
        x -= SPRITE_BONE_TOP_WIDTH + G_GAP_X;
    }
}

static void g_update(uint8_t id) {
    (void)id;
    for (uint8_t i = 0; i < G_COUNT; i++) {
        g_positions[i].x += G_SPEED;
    }
}

static void g_draw(uint8_t id) {
    (void)id;

    sans_clip_box();

    for (uint8_t i = 0; i < G_COUNT; i++) {
        vec24i_t position = g_positions[i];
        uint8_t height = position.y - SANS_UI_BOX_DEFAULT_TOP - G_BONE_ENDS;
        sans_bone_draw_clip(position, height);

        uint8_t total_height = G_BONE_ENDS + G_GAP_Y + height;
        position.y = SANS_UI_BOX_BOTTOM;
        height = SANS_UI_BOX_DEFAULT_HEIGHT - G_BONE_ENDS - total_height;

        sans_bone_draw_clip(position, height);
    }
}

void g_add_colliders(void) {
    // TODO: Handle malloc error
    g_colliders = malloc(sizeof(sans_physics_collider_id_t) * G_COUNT);

    vec2_t size = vec2(G_GAP_X, G_GAP_Y);

    for (uint8_t i = 0; i < G_COUNT; i++) {
        g_colliders[i] = sans_physics_list_push_column_gap(
            &g_positions[i],
            size
        );
    }
}

void g_remove_colliders(void) {
    for (uint8_t i = 0; i < G_COUNT; i++) {
        sans_physics_list_remove(g_colliders[i]);
    }

    free(g_colliders);
}

void sans_bone_wave_spawn(void) {
    g_entity = sans_entity_push(g_update, g_draw, 0);
    g_add_colliders();
}

void sans_bone_wave_remove(void) {
    sans_entity_remove(g_entity);
    g_remove_colliders();
}
