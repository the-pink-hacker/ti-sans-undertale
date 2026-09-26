#pragma once

#include <graphx.h>
#include <stdint.h>

#include "vec.h"

// Draws a bone with a top upwards from the provided position
void sans_bone_draw_top(vec24_t position, uint8_t height);

// Draws a bone with a top and bottom upwards from the provided position
void sans_bone_draw_clip(vec24i_t position, uint8_t height);
