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
#define G_SIZE 56

typedef struct {
    uint8_t width;
    uint8_t height;
    uint8_t pixels[G_SIZE * G_SIZE];
} sans_blaster_sprite_t;

typedef struct {
    sans_blaster_sprite_t sprites[20];
} sans_blaster_file_t;

static sans_entity_handle_t g_entities_4a[4];
static sans_blaster_position_t *g_positions_4a;
static uint8_t g_frames_4a = 0;

static sans_blaster_file_t *g_files[G_FILE_COUNT];

sans_result_t g_load_file(uint8_t index) {
    static char name[8] = "SANSGB0";
    name[6] = '0' + index;
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

const gfx_sprite_t *sans_blaster_get_sprite(uint8_t frame, uint8_t rotation_index) {
    //gfx_sprite_t *sprite = (gfx_sprite_t *)&g_files[frame]->sprites[rotation_index];
    return (gfx_sprite_t *)&g_files[frame]->sprites[0];
}

static sans_blaster_position_t *g_alloc_position_list(uint8_t length) {
    // TODO: Handle malloc error
    return (sans_blaster_position_t *)malloc(sizeof(sans_blaster_position_t) * length);
}

static void g_update(uint8_t id) {
    (void)id;

    if (g_frames_4a >= SANS_LOOKUP_BLASTER_4A_FRAMES) {
        return;
    }

    memcpy(
        g_positions_4a,
        &SANS_LOOKUP_BLASTER_4A_TABLE[g_frames_4a],
        sizeof(sans_blaster_position_t) * 4
    );

    g_frames_4a++;
}

static void g_draw_blaster(sans_blaster_position_t *position, uint8_t frame) {
    sans_sprite_run_length_draw(
        sans_blaster_get_sprite(frame, position->rotation_index),
        position->position
    );
}

static void g_draw(uint8_t id) {
    (void)id;

    g_draw_blaster(&g_positions_4a[id], 0);
}

void sans_blaster_spawn_4a(void) {
    g_positions_4a = g_alloc_position_list(4);

    for (uint8_t i = 0; i < 4; i++) {
        g_entities_4a[i] = sans_entity_push(g_update, g_draw, i);
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
