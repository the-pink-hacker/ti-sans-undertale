#include "heart.h"

#include <sys/lcd.h>

#include <graphx.h>

#include "input.h"
#include "generated/sprites/player.h"

static uint24_t _heart_x = LCD_WIDTH / 2;
static uint8_t _heart_y = LCD_HEIGHT / 2;

void sans_heart_update(void) {
    uint24_t x = _heart_x;
    uint8_t y = _heart_y;

    if (sans_input_pressing_left()) {
        x--;
    }

    if (sans_input_pressing_right()) {
        x++;
    }

    if (sans_input_pressing_up()) {
        y--;
    }

    if (sans_input_pressing_down()) {
        y++;
    }

    _heart_x = x;
    _heart_y = y;
}

void sans_heart_draw(void) {
    gfx_Sprite(&sprite_heart_red, _heart_x, _heart_y);
}
