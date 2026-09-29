#include "blaster.h"

#include <fileioc.h>
#include <debug.h>
#include <graphx.h>

#include "entity.h"

#define G_FILE_COUNT 6
#define G_SIZE 56

static uint8_t g_f = 5;
static uint8_t g_i = 19;

typedef struct {
    uint8_t width;
    uint8_t height;
    uint8_t pixels[G_SIZE * G_SIZE];
} sans_blaster_sprite_t;

typedef struct {
    sans_blaster_sprite_t sprites[20];
} sans_blaster_file_t;

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
    gfx_sprite_t *sprite = (gfx_sprite_t *)&g_files[frame]->sprites[rotation_index];
    return sprite;
}

static void g_update(uint8_t id) {
    (void)id;
    
    if (g_i < 19) {
        g_i++;
    } else {
        g_i = 0;

        if (g_f < 5) {
            g_f++;
        } else {
            g_f = 0;
        }
    }
    dbg_Debugger();
    dbg_printf("%i: %i\n", (int)g_f, (int)g_i);
}

static void g_draw(uint8_t id) {
    (void)id;
    gfx_TransparentSprite_NoClip(sans_blaster_get_sprite(g_f, g_i), 0, 0);
}

void sans_blaster_spawn(void) {
    sans_entity_push(g_update, g_draw, 0);
}
