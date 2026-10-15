#include "blaster.h"

#include <fileioc.h>
#include <graphx.h>
#include <debug.h>
#include <string.h>

#include "entity.h"
#include "clip.h"
#include "sprite.h"
#include "generated/lookup/blaster_4a.h"

#define G_FILE_COUNT 6
#define G_SIZE 68
#define G_SPEED_OUT 10

typedef struct {
    gfx_rletsprite_t *sprites[20];
} sans_blaster_file_t;

static sans_entity_handle_t g_entities_4a[4];
static sans_blaster_position_t *g_positions_4a;
static uint8_t g_animation_frames_4a[4];
static uint8_t g_frames_4a;

static sans_blaster_file_t *g_files[G_FILE_COUNT];

static sans_result_t g_load_file(uint8_t index) {
    static char name[9] = "SANSGB0?";
    name[7] = '0' + index;
    dbg_printf("Attempting to load: %s\n", name);
    uint8_t file = ti_Open(name, "r");

    if (file == 0) {
        RETURN_ERROR(SANS_BLASTER_MISSING);
    }

    g_files[index] = (sans_blaster_file_t *)ti_GetDataPtr(file);
    ti_Close(file);

    return SANS_SUCCESS;
}

sans_result_t sans_blaster_init(void) {
    for (uint8_t i = 0; i < G_FILE_COUNT; i++) {
        EARLY_EXIT(g_load_file(i));
    }

    return SANS_SUCCESS;
}

const gfx_rletsprite_t *g_get_sprite(uint8_t frame, uint8_t rotation_index) {
    uint24_t offset = (uint24_t)g_files[frame]->sprites[rotation_index];
    uint24_t file_offset = (uint24_t)g_files[frame];

    return (gfx_rletsprite_t *)(offset + file_offset);
}

static sans_blaster_position_t *g_alloc_position_list(uint8_t length) {
    // TODO: Handle malloc error
    return (sans_blaster_position_t *)malloc(sizeof(sans_blaster_position_t) * length);
}

static void g_4a_update_slide_in(void) {
    memcpy(
        g_positions_4a,
        &SANS_LOOKUP_BLASTER_4A_TABLE[g_frames_4a],
        sizeof(sans_blaster_position_t) * 4
    );
}

static void g_animate(uint8_t *frame) {
    if (*frame <= 4) {
        (*frame)++;
    } else {
        // Toggle betweeen 4 and 5
        *frame ^= (4 ^ 5);
    }
}

static void g_4a_update(uint8_t id) {
    if (g_frames_4a < SANS_LOOKUP_BLASTER_4A_FRAMES) {
        if (id == 0) {
            // Updates all the blasters
            g_4a_update_slide_in();
            // No other blasters ran, so update frame
            g_frames_4a++;
        }
    } else {
        switch (id) {
            // Top
            case 0:
                if (g_frames_4a >= 22) {
                    g_animate(&g_animation_frames_4a[id]);
                }

                if (g_frames_4a >= 28) {
                    g_positions_4a[id].position.y -= G_SPEED_OUT;
                }
                break;
            // Left
            case 1:
                if (g_frames_4a >= 22) {
                    g_animate(&g_animation_frames_4a[id]);
                }

                if (g_frames_4a >= 28) {
                    g_positions_4a[id].position.x -= G_SPEED_OUT;
                }
                break;
            // Bottom
            case 2:
                if (g_frames_4a >= 21) {
                    g_animate(&g_animation_frames_4a[id]);
                }

                if (g_frames_4a >= 27) {
                    g_positions_4a[id].position.y += G_SPEED_OUT;
                }
                break;
            // Right
            case 3:
                if (g_frames_4a >= 20) {
                    g_animate(&g_animation_frames_4a[id]);
                }

                if (g_frames_4a >= 26) {
                    g_positions_4a[id].position.x += G_SPEED_OUT;
                }

                // Last blaster ran, so update frame
                g_frames_4a++;
                break;
        }
    }

}

static void g_draw_blaster(sans_blaster_position_t *position, uint8_t frame) {
    gfx_RLETSprite(
        g_get_sprite(frame, position->rotation_index),
        position->position.x,
        position->position.y
    );
}

static void g_4a_draw(uint8_t id) {
    // Blasters should be rendered back to back
    if (id == 0) {
        sans_clip_screen();
    }

    g_draw_blaster(&g_positions_4a[id], g_animation_frames_4a[id]);
}

void sans_blaster_spawn_4a(void) {
    g_frames_4a = 0;
    g_positions_4a = g_alloc_position_list(4);
    memset(&g_animation_frames_4a, 0, sizeof(g_animation_frames_4a));

    for (uint8_t i = 0; i < 4; i++) {
        g_entities_4a[i] = sans_entity_push(g_4a_update, g_4a_draw, i);
    }
}

void sans_blaster_remove_4a(void) {
    free(g_positions_4a);

    for (uint8_t i = 0; i < 4; i++) {
        sans_entity_remove(g_entities_4a[i]);
    }
}

void sans_blaster_spawn_4b(void) {}

void sans_blaster_remove_4b(void) {}

void sans_blaster_spawn_2(void) {}

void sans_blaster_remove_2(void) {}
