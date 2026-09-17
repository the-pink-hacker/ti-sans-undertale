#include "button.h"

#include <graphx.h>
#include <stdint.h>
#include <fontlibc.h>

#define G_BUTTON_WIDTH 57
#define G_BUTTON_HEIGHT 23
#define G_BUTTON_Y 214
#define G_BUTTON_FIGHT_X 15
#define G_BUTTON_ACT_X 92
#define G_BUTTON_ITEM_X 172
#define G_BUTTON_MERCY_X 249

#define G_BUTTON_COUNT 4

#include "font.h"
#include "../vec.h"
#include "../color.h"
#include "../heart.h"
#include "../input.h"
#include "../generated/sprites/ui.h"
#include "../generated/sprites/heart.h"

typedef enum {
    SANS_BUTTON_UNSELECTED,
    SANS_BUTTON_RED,
    SANS_BUTTON_BLUE,
} sans_ui_button_state_t;

static uint8_t g_selected_index = 0;

static void g_select_right(void) {
    if (g_selected_index >= G_BUTTON_COUNT - 1) {
        g_selected_index = 0;
    } else {
        g_selected_index++;
    }
}

static void g_select_left(void) {
    if (g_selected_index == 0) {
        g_selected_index = G_BUTTON_COUNT - 1;
    } else {
        g_selected_index--;
    }
}

void sans_ui_button_select_reset(void) {
    g_selected_index = 0;
}

void sans_ui_button_update(void) {
    if (sans_input_get_focus() != SANS_INPUT_FOCUS_BUTTON) {
        return;
    }

    if (sans_input_pressed_enter()) {
        sans_input_set_focus(SANS_INPUT_FOCUS_HEART);
        return;
    }

    if (sans_input_pressed_right()) {
        g_select_right();
    } else if (sans_input_pressed_left()) {
        g_select_left();
    }
}

static void g_draw_button(
    sans_ui_button_state_t state,
    const vec24_t *position,
    const gfx_sprite_t *icon,
    char text_index,
    uint8_t text_offset_x,
    uint8_t icon_offset_x,
    uint8_t icon_offset_y
) {
    switch (state) {
        case SANS_BUTTON_UNSELECTED:
            sans_ui_font_set_color_orange();
            gfx_SetColor(SANS_COLOR_ORANGE);
            break;
        case SANS_BUTTON_RED:
            sans_ui_font_set_color_yellow();
            gfx_SetColor(SANS_COLOR_YELLOW);
            icon = &sprite_heart_red;
            icon_offset_x = 5;
            icon_offset_y = 8;
            break;
        case SANS_BUTTON_BLUE:
            sans_ui_font_set_color_yellow();
            gfx_SetColor(SANS_COLOR_YELLOW);
            icon = &sprite_heart_blue;
            icon_offset_x = 5;
            icon_offset_y = 8;
            break;
    }

    uint24_t x = position->x;
    uint8_t y = position->y;

    // Box
    gfx_Rectangle_NoClip(x, y, G_BUTTON_WIDTH, G_BUTTON_HEIGHT);
    gfx_Rectangle_NoClip(x + 1, y + 1, G_BUTTON_WIDTH - 2, G_BUTTON_HEIGHT - 2);

    // icon
    gfx_Sprite_NoClip(icon, x + icon_offset_x, y + icon_offset_y);

    // Text
    fontlib_SetCursorPosition(x + text_offset_x, y + 5);
    fontlib_DrawGlyph(text_index);
    fontlib_DrawGlyph(text_index + 1);
}

static sans_ui_button_state_t g_get_selected_state(void) {
    switch (sans_heart_get_state()) {
        case SANS_HEART_STATE_RED:
            return SANS_BUTTON_RED;
        case SANS_HEART_STATE_BLUE:
            return SANS_BUTTON_BLUE;
    }
}

static sans_ui_button_state_t g_get_state(sans_ui_button_state_t selected_state, uint8_t index) {
    if (index == g_selected_index
            && sans_input_get_focus() == SANS_INPUT_FOCUS_BUTTON
    ) {
        return selected_state;
    } else {
        return SANS_BUTTON_UNSELECTED;
    }
}

void sans_ui_button_draw(void) {
    sans_ui_font_set_button();
    vec24_t position = vec2(G_BUTTON_FIGHT_X, G_BUTTON_Y);
    sans_ui_button_state_t state = g_get_selected_state();
    g_draw_button(
        g_get_state(state, 0),
        &position,
        &sprite_button_fight_icon,
        '0',
        16,
        5,
        5
    );
    position.x = G_BUTTON_ACT_X;
    g_draw_button(
        g_get_state(state, 1),
        &position,
        &sprite_button_act_icon,
        '2',
        18,
        7,
        7
    );
    position.x = G_BUTTON_ITEM_X;
    g_draw_button(
        g_get_state(state, 2),
        &position,
        &sprite_button_item_icon,
        '4',
        16,
        5,
        5
    );
    position.x = G_BUTTON_MERCY_X;
    g_draw_button(
        g_get_state(state, 3),
        &position,
        &sprite_button_mercy_icon,
        '6',
        16,
        6,
        7
    );
}
