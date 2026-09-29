#pragma once

#include <graphx.h>
#include <stdint.h>

#include "error.h"

sans_result_t sans_blaster_init(void);

const gfx_sprite_t *sans_blaster_get_sprite(uint8_t frame, uint8_t rotation_index);

void sans_blaster_spawn(void);
