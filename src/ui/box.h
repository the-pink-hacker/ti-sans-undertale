#pragma once

#include "../vec.h"

#define SANS_UI_BOX_BOTTOM 192
#define SANS_UI_BOX_DEFAULT_WIDTH 78
#define SANS_UI_BOX_DEFAULT_HEIGHT 78
#define SANS_UI_BOX_DEFAULT_TOP (SANS_UI_BOX_BOTTOM - SANS_UI_BOX_DEFAULT_HEIGHT)
#define SANS_UI_BOX_DEFAULT_LEFT 122
#define SANS_UI_BOX_DEFAULT_RIGHT (SANS_UI_BOX_DEFAULT_LEFT + SANS_UI_BOX_DEFAULT_WIDTH)

void sans_ui_box_update(void);

void sans_ui_box_draw(void);

vec24_t sans_ui_box_position(void);

vec24_t sans_ui_box_get_size(void);

void sans_ui_box_set_size_default(void);

void sans_ui_box_transition_wide(void);

void sans_ui_box_transition_default(void);

// Sets size to zero and doesn't render
void sans_ui_box_disable(void);
