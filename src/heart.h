#pragma once

#include "direction.h"
#include "vec.h"

#include <stdint.h>

typedef enum {
    SANS_HEART_STATE_RED,
    SANS_HEART_STATE_BLUE,
} sans_heart_state_t;

void sans_heart_update(void);

void sans_heart_draw(void);

void sans_heart_set_red(void);

void sans_heart_set_blue(void);

// Skips rendering and updates while disabled
void sans_heart_disable(void);

void sans_heart_set_position(vec24_t position);

void sans_heart_set_position_default(void);

void sans_heart_throw(sans_direction_t direction);

sans_heart_state_t sans_heart_get_state(void);
