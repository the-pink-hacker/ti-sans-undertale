#pragma once

#include <stdint.h>

typedef enum {
    SANS_HEART_STATE_RED,
    SANS_HEART_STATE_BLUE,
} sans_heart_state_t;

void sans_heart_update(void);

void sans_heart_draw(void);

void sans_heart_set_red(void);

void sans_heart_set_blue(void);

void sans_heart_disable(void);

sans_heart_state_t sans_heart_get_state(void);
