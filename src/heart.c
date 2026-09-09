#include "heart.h"

#include <sys/lcd.h>
#include <graphx.h>
#include <math.h>

#include "input.h"
#include "physics.h"
#include "vec.h"
#include "attack_box.h"
#include "generated/sprites/heart.h"

// Amount of speed added per frame when red
#define _SPEED 2.5
// Amount of speed added per frame when falling
#define _GRAVITY 0.5
// Max downwards speed
#define _GRAVITY_MAX 2.5
// The amount of velocity added on jump
#define _JUMP 2.5
// How many frames to jump
#define _JUMP_FRAMES 12

typedef enum {
    SANS_HEART_STATE_RED,
    SANS_HEART_STATE_BLUE,
} sans_heart_state_t;

typedef enum {
    // Heart is being thrown
    SANS_HEART_MOVEMENT_THROW,
} sans_heart_movement_t;

static vec2f_t _heart_position = {
    .x = LCD_WIDTH / 2.0,
    .y = LCD_HEIGHT / 2.0,
};
// Updated based on the float position. Used for rendering.
static vec24_t _heart_int_position = {
    .x = 0.0,
    .y = 0.0,
};
static vec2f_t _heart_velocity = {
    .x = 0.0,
    .y = 0.0,
};
static const vec2_t _heart_size = {
    .x = SPRITE_HEART_RED_WIDTH,
    .y = SPRITE_HEART_RED_HEIGHT,
};
static sans_heart_state_t _state = SANS_HEART_STATE_RED;
static const gfx_sprite_t *_sprite = &sprite_heart_red;

static bool _grounded = false;
// How many frames of jumping are left
static uint8_t _jump_frames = 0;

static void _move_horizontal() {
    if (sans_input_pressing_left()) {
        _heart_velocity.x -= _SPEED;
    }

    if (sans_input_pressing_right()) {
        _heart_velocity.x += _SPEED;
    }
}

static void _move_red() {
    _heart_velocity.x = 0.0;
    _heart_velocity.y = 0.0;

    _move_horizontal();

    if (sans_input_pressing_up()) {
        _heart_velocity.y -= _SPEED;
    }

    if (sans_input_pressing_down()) {
        _heart_velocity.y += _SPEED;
    }
}

// Adds gravity force to velocity
static void _apply_gravity(void) {
    float new_y = _heart_velocity.y + _GRAVITY;

    if (new_y > _GRAVITY_MAX) {
        _heart_velocity.y = _GRAVITY_MAX;
    } else {
        _heart_velocity.y = new_y;
    }
}

// Sets the flags to get ready for a jump
static void _start_jump(void) {
    _jump_frames = _JUMP_FRAMES;
}

// Adds jump force to velocity
static void _apply_jump(void) {
    _heart_velocity.y = -_JUMP;
    _jump_frames--;
}

static void _move_blue(void) {
    // Reset x velocity
    _heart_velocity.x = 0.0;

    _move_horizontal();

    bool pressing_up = sans_input_pressing_up();

    if (_grounded && pressing_up) {
        _start_jump();
    }

    if (_jump_frames > 0) {
        // Is no longer press jump; cancel jumping
        if (sans_input_was_pressing_up() && !pressing_up) {
            _jump_frames = 0;
            _apply_gravity();
        } else {
            _apply_jump();
        }
    } else {
        _apply_gravity();
    }
}

// Updates the integer position to the current float position
static void _update_int_position(void) {
    _heart_int_position.x = lround(_heart_position.x);
    _heart_int_position.y = lround(_heart_position.y);
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
            _move_red();
            break;
        case SANS_HEART_STATE_BLUE:
            _move_blue();
            break;
    }

    // Apply velocity
    _heart_position.x += _heart_velocity.x;
    _heart_position.y += _heart_velocity.y;

    _grounded = false;

    _update_int_position();

    vec24_t old_position = _heart_int_position;

    // Clamps the player's position within the attack box
    sans_physics_clamp_within_box(
        &_heart_int_position,
        _heart_size,
        sans_attack_box_position(),
        sans_attack_box_size(),
        &_grounded
    );

    // Correct the float x if clamped
    if (old_position.x != _heart_int_position.x) {
        _heart_position.x = (uint24_t)_heart_int_position.x;
        _heart_velocity.x = 0.0;
    }

    // Correct the float y if clamped
    if (old_position.y != _heart_int_position.y) {
        _heart_position.y = (uint8_t)_heart_int_position.y;
        _heart_velocity.y = 0.0;
    }
}

void sans_heart_draw(void) {
    gfx_TransparentSprite_NoClip(_sprite, _heart_int_position.x, _heart_int_position.y);
}

void sans_heart_set_red(void) {
    _sprite = &sprite_heart_red;
    _state = SANS_HEART_STATE_RED;
}

void sans_heart_set_blue(void) {
    _sprite = &sprite_heart_blue;
    _state = SANS_HEART_STATE_BLUE;
}
