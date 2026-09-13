#include "button.h"

#include <graphx.h>
#include <stdint.h>
#include <fontlibc.h>

#define _BUTTON_WIDTH 57
#define _BUTTON_HEIGHT 23
#define _BUTTON_Y 214
#define _BUTTON_FIGHT_X 15
#define _BUTTON_ACT_X 92
#define _BUTTON_ITEM_X 172
#define _BUTTON_MERCY_X 249

#include "font.h"
#include "../vec.h"
#include "../color.h"
#include "../generated/sprites/ui.h"
#include "../generated/sprites/heart.h"

typedef enum {
    SANS_BUTTON_UNSELECTED,
    SANS_BUTTON_RED,
    SANS_BUTTON_BLUE,
} sans_ui_button_state_t;

static void _draw_button(
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
            gfx_SetColor(ORANGE);
            break;
        case SANS_BUTTON_RED:
            sans_ui_font_set_color_yellow();
            gfx_SetColor(YELLOW);
            icon = &sprite_heart_red;
            icon_offset_y = 8;
            break;
        case SANS_BUTTON_BLUE:
            sans_ui_font_set_color_yellow();
            gfx_SetColor(YELLOW);
            icon = &sprite_heart_blue;
            icon_offset_y = 8;
            break;
    }

    uint24_t x = position->x;
    uint8_t y = position->y;

    // Box
    gfx_Rectangle_NoClip(x, y, _BUTTON_WIDTH, _BUTTON_HEIGHT);
    gfx_Rectangle_NoClip(x + 1, y + 1, _BUTTON_WIDTH, _BUTTON_HEIGHT);

    // icon
    gfx_Sprite_NoClip(icon, x + icon_offset_x, y + icon_offset_y);

    // Text
    fontlib_SetCursorPosition(x + text_offset_x, y + 5);
    fontlib_DrawGlyph(text_index);
    fontlib_DrawGlyph(text_index + 1);
}

void sans_ui_button_draw(void) {
    sans_ui_font_set_button();
    vec24_t position = vec2(_BUTTON_FIGHT_X, _BUTTON_Y);
    _draw_button(
        SANS_BUTTON_RED,
        &position,
        &sprite_button_fight_icon,
        '0',
        16,
        5,
        5
    );
    position.x = _BUTTON_ACT_X;
    _draw_button(
        SANS_BUTTON_BLUE,
        &position,
        &sprite_button_act_icon,
        '2',
        18,
        7,
        7
    );
    position.x = _BUTTON_ITEM_X;
    _draw_button(
        SANS_BUTTON_UNSELECTED,
        &position,
        &sprite_button_item_icon,
        '4',
        16,
        5,
        5
    );
    position.x = _BUTTON_MERCY_X;
    _draw_button(
        SANS_BUTTON_UNSELECTED,
        &position,
        &sprite_button_mercy_icon,
        '6',
        16,
        6,
        7
    );
}
