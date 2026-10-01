#pragma once

#include <graphx.h>
#include <stdint.h>

#include "error.h"
#include "vec.h"

typedef struct {
    vec2i_t position;
    uint8_t rotation_index;
} sans_blaster_position_t;

sans_result_t sans_blaster_init(void);

const gfx_sprite_t *sans_blaster_get_sprite(uint8_t frame, uint8_t rotation_index);

void sans_blaster_spawn_4a(void);

void sans_blaster_remove_4a(void);

void sans_blaster_spawn_4b(void);

void sans_blaster_remove_4b(void);

void sans_blaster_spawn_2(void);

void sans_blaster_remove_2(void);
