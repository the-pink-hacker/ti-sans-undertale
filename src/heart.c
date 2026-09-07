#include "heart.h"

#include <sys/lcd.h>
#include <graphx.h>

#include "input.h"
#include "physics.h"
#include "math.h"
#include "attack_box.h"
#include "generated/sprites/heart.h"

#define _SPEED 1

typedef enum {
    SANS_HEART_STATE_RED,
    SANS_HEART_STATE_BLUE,
} sans_heart_state_t;

static vec24_t _heart_position = {
    .x = LCD_WIDTH / 2,
    .y = LCD_HEIGHT / 2,
};
static vec2_t _heart_size = {
    .x = SPRITE_HEART_RED_WIDTH,
    .y = SPRITE_HEART_RED_HEIGHT,
};
static sans_heart_state_t _state = SANS_HEART_STATE_RED;
static const gfx_sprite_t *_sprite = &sprite_heart_red;

static void _move_red(vec24_t *position) {
    uint24_t delta_x = 0;
    uint8_t delta_y = 0;

    if (sans_input_pressing_left()) {
        delta_x -= _SPEED;
    }

    if (sans_input_pressing_right()) {
        delta_x += _SPEED;
    }

    if (sans_input_pressing_up()) {
        delta_y -= _SPEED;
    }

    if (sans_input_pressing_down()) {
        delta_y += _SPEED;
    }

    position->x += delta_x;
    position->y += delta_y;
}

void sans_heart_update(void) {
    if (sans_input_pressing_debug_heart_red()) {
        sans_heart_set_red();
    } else if (sans_input_pressing_debug_heart_blue()) {
        sans_heart_set_blue();
    }

    vec24_t new_position = _heart_position;

    // Movement based on current state
    switch (_state) {
        case SANS_HEART_STATE_RED:
            _move_red(&new_position);
            break;
        case SANS_HEART_STATE_BLUE:
            break;
    }

    // Check if colliding attack_box
    vec24_t attack_box_position = sans_attack_box_position();
    vec2_t attack_box_size = sans_attack_box_size();

    if (!sans_physics_collision_within_box(new_position, _heart_size, attack_box_position, attack_box_size)) {
        return;
    }

    _heart_position = new_position;
}

void sans_heart_draw(void) {
    gfx_TransparentSprite_NoClip(_sprite, _heart_position.x, _heart_position.y);
}

void sans_heart_set_red(void) {
    _sprite = &sprite_heart_red;
    _state = SANS_HEART_STATE_RED;
}

void sans_heart_set_blue(void) {
    _sprite = &sprite_heart_blue;
    _state = SANS_HEART_STATE_BLUE;
}
