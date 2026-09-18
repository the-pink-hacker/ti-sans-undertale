#pragma once

#include "../vec.h"

void snas_ui_box_update(void);

void sans_ui_box_draw(void);

vec24_t sans_ui_box_position(void);

vec2_t sans_ui_box_get_size(void);

void sans_ui_box_set_size_default(void);

void sans_ui_box_transition_wide(void);

void sans_ui_box_transition_default(void);

// Sets size to zero and doesn't render
void sans_ui_box_disable(void);
