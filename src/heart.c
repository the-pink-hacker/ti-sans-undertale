#include "heart.h"

#include <sys/lcd.h>

#include <graphx.h>

#include "input.h"
#include "generated/sprites/heart.h"

typedef enum {
    SANS_HEART_STATE_RED,
    SANS_HEART_STATE_BLUE,
} sans_heart_state_t;

static uint24_t _heart_x = LCD_WIDTH / 2;
static uint8_t _heart_y = LCD_HEIGHT / 2;
static sans_heart_state_t _state = SANS_HEART_STATE_RED;
static const gfx_sprite_t *_sprite = &sprite_heart_red;

static void _move_red(uint24_t *x, uint8_t *y) {
    uint24_t delta_x = 0;
    uint8_t delta_y = 0;

    if (sans_input_pressing_left()) {
        delta_x--;
    }

    if (sans_input_pressing_right()) {
        delta_x++;
    }

    if (sans_input_pressing_up()) {
        delta_y--;
    }

    if (sans_input_pressing_down()) {
        delta_y++;
    }

    *x += delta_x;
    *y += delta_y;
}

void sans_heart_update(void) {
    if (sans_input_pressing_debug_heart_red()) {
        sans_heart_set_red();
    } else if (sans_input_pressing_debug_heart_blue()) {
        sans_heart_set_blue();
    }

    uint24_t x = _heart_x;
    uint8_t y = _heart_y;

    switch (_state) {
        case SANS_HEART_STATE_RED:
            _move_red(&x, &y);
            break;
        case SANS_HEART_STATE_BLUE:
            break;
    }

    _heart_x = x;
    _heart_y = y;
}

void sans_heart_draw(void) {
    gfx_Sprite(_sprite, _heart_x, _heart_y);
}

void sans_heart_set_red(void) {
    _sprite = &sprite_heart_red;
    _state = SANS_HEART_STATE_RED;
}

void sans_heart_set_blue(void) {
    _sprite = &sprite_heart_blue;
    _state = SANS_HEART_STATE_BLUE;
}
