#include "heart.h"

#include <sys/lcd.h>
#include <graphx.h>

#include "input.h"
#include "physics.h"
#include "math.h"
#include "attack_box.h"
#include "generated/sprites/heart.h"

#define _SPEED 2
#define _GRAVITY 2

typedef enum {
    SANS_HEART_STATE_RED,
    SANS_HEART_STATE_BLUE,
} sans_heart_state_t;

static vec24_t _heart_position = {
    .x = LCD_WIDTH / 2,
    .y = LCD_HEIGHT / 2,
};
static vec24_t _heart_velocity = {
    .x = 0,
    .y = 0,
};
static vec2_t _heart_size = {
    .x = SPRITE_HEART_RED_WIDTH,
    .y = SPRITE_HEART_RED_HEIGHT,
};
static sans_heart_state_t _state = SANS_HEART_STATE_RED;
static const gfx_sprite_t *_sprite = &sprite_heart_red;

static void _move_horizontal(vec24_t *delta) {
    if (sans_input_pressing_left()) {
        delta->x -= _SPEED;
    }

    if (sans_input_pressing_right()) {
        delta->x += _SPEED;
    }
}

static void _move_red(vec24_t *velocity) {
    vec24_t delta = {
        .x = 0,
        .y = 0,
    };

    _move_horizontal(&delta);

    if (sans_input_pressing_up()) {
        delta.y -= _SPEED;
    }

    if (sans_input_pressing_down()) {
        delta.y += _SPEED;
    }

    *velocity = delta;
}

static void _move_blue(vec24_t *velocity) {
    vec24_t delta = {
        .x = 0,
        .y = _GRAVITY,
    };

    _move_horizontal(&delta);

    *velocity = delta;
}

void sans_heart_update(void) {
    if (sans_input_pressing_debug_heart_red()) {
        sans_heart_set_red();
    } else if (sans_input_pressing_debug_heart_blue()) {
        sans_heart_set_blue();
    }

    // Movement based on current state
    switch (_state) {
        case SANS_HEART_STATE_RED:
            _move_red(&_heart_velocity);
            break;
        case SANS_HEART_STATE_BLUE:
            _move_blue(&_heart_velocity);
            break;
    }

    // Apply velocity
    _heart_position.x += _heart_velocity.x;
    _heart_position.y += _heart_velocity.y;

    // Clamps the player's position within the attack box
    sans_physics_clamp_within_box(
        &_heart_position,
        _heart_size,
        sans_attack_box_position(),
        sans_attack_box_size()
    );
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
