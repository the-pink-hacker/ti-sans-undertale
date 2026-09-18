#include "heart.h"

#include <sys/lcd.h>
#include <graphx.h>
#include <math.h>

#include "input.h"
#include "physics.h"
#include "vec.h"
#include "ui/box.h"
#include "generated/sprites/heart.h"

// Amount of speed added per frame when red
#define G_SPEED 2.5
// Amount of speed added per frame when falling
#define G_GRAVITY 0.5
// Max downwards speed
#define G_GRAVITY_MAX 2.5
// The amount of velocity added on jump
#define G_JUMP 2.5
// How many frames to jump
#define G_JUMP_FRAMES 12

#define G_THROW_SPEED 20

#define G_BOX_X 120
#define G_BOX_Y 112
#define G_BOX_SIZE 80
#define G_POSITION_DEFAULT_X (G_BOX_X + (G_BOX_SIZE / 2) - (SPRITE_HEART_RED_WIDTH / 2))
#define G_POSITION_DEFAULT_Y (G_BOX_Y + (G_BOX_SIZE / 2) - (SPRITE_HEART_RED_HEIGHT / 2))

static vec2f_t g_heart_position = vec2(G_POSITION_DEFAULT_X, G_POSITION_DEFAULT_Y);
// Updated based on the float position. Used for rendering.
static vec24_t g_heart_int_position = vec2(0.0, 0.0);
static vec2f_t g_heart_velocity = vec2(0.0, 0.0);
static const vec2_t g_heart_size = vec2(SPRITE_HEART_RED_WIDTH, SPRITE_HEART_RED_HEIGHT);
static sans_heart_state_t g_state = SANS_HEART_STATE_RED;
static const gfx_sprite_t *g_sprite = &sprite_heart_red;

static bool g_grounded = false;
// How many frames of jumping are left
static uint8_t g_jump_frames = 0;

static bool g_disable = false;

static void g_move_horizontal() {
    if (sans_input_pressing_left()) {
        g_heart_velocity.x -= G_SPEED;
    }

    if (sans_input_pressing_right()) {
        g_heart_velocity.x += G_SPEED;
    }
}

static bool g_check_focus(void) {
    return sans_input_get_focus() == SANS_INPUT_FOCUS_HEART;
}

static void g_move_red() {
    g_heart_velocity.x = 0.0;
    g_heart_velocity.y = 0.0;

    // Check if heart is being controlled
    if (!g_check_focus()) {
        return;
    }

    g_move_horizontal();

    if (sans_input_pressing_up()) {
        g_heart_velocity.y -= G_SPEED;
    }

    if (sans_input_pressing_down()) {
        g_heart_velocity.y += G_SPEED;
    }
}

// Adds gravity force to velocity
static void g_apply_gravity(void) {
    float new_y = g_heart_velocity.y + G_GRAVITY;

    if (new_y > G_GRAVITY_MAX) {
        g_heart_velocity.y = G_GRAVITY_MAX;
    } else {
        g_heart_velocity.y = new_y;
    }
}

// Sets the flags to get ready for a jump
static void g_start_jump(void) {
    g_jump_frames = G_JUMP_FRAMES;
}

// Adds jump force to velocity
static void g_apply_jump(void) {
    g_heart_velocity.y = -G_JUMP;
    g_jump_frames--;
}

static void g_move_blue(void) {
    // Reset x velocity
    g_heart_velocity.x = 0.0;

    // Check if heart is being controlled
    if (g_check_focus()) {
        g_move_horizontal();

        bool pressing_up = sans_input_pressing_up();

        if (g_grounded && pressing_up) {
            g_start_jump();
        }

        if (g_jump_frames > 0) {
            // Is no longer press jump; cancel jumping
            if (sans_input_was_pressing_up() && !pressing_up) {
                g_jump_frames = 0;
            } else {
                g_apply_jump();
                return;
            }
        }
    }

    g_apply_gravity();
}

// Updates the integer position to the current float position
static void g_update_int_position(void) {
    g_heart_int_position.x = lround(g_heart_position.x);
    g_heart_int_position.y = lround(g_heart_position.y);
}

void sans_heart_update(void) {
    if (g_disable) {
        return;
    }

    if (sans_input_pressing_debug_heart_red()) {
        sans_heart_set_red();
    } else if (sans_input_pressing_debug_heart_blue()) {
        sans_heart_set_blue();
    }

    // Movement based on current state
    switch (g_state) {
        case SANS_HEART_STATE_RED:
            g_move_red();
            break;
        case SANS_HEART_STATE_BLUE:
            g_move_blue();
            break;
    }

    // Apply velocity
    g_heart_position.x += g_heart_velocity.x;
    g_heart_position.y += g_heart_velocity.y;

    g_grounded = false;

    g_update_int_position();

    vec24_t old_position = g_heart_int_position;

    // Clamps the player's position within the attack box
    sans_physics_clamp_within_box(
        &g_heart_int_position,
        g_heart_size,
        sans_ui_box_position(),
        sans_ui_box_get_size(),
        &g_grounded
    );

    // Correct the float x if clamped
    if (old_position.x != g_heart_int_position.x) {
        g_heart_position.x = (uint24_t)g_heart_int_position.x;
        g_heart_velocity.x = 0.0;
    }

    // Correct the float y if clamped
    if (old_position.y != g_heart_int_position.y) {
        g_heart_position.y = (uint8_t)g_heart_int_position.y;
        g_heart_velocity.y = 0.0;
    }
}

void sans_heart_draw(void) {
    if (g_disable) {
        return;
    }

    gfx_TransparentSprite_NoClip(g_sprite, g_heart_int_position.x, g_heart_int_position.y);
}

void sans_heart_set_red(void) {
    g_sprite = &sprite_heart_red;
    g_state = SANS_HEART_STATE_RED;
    g_disable = false;
}

void sans_heart_set_blue(void) {
    g_sprite = &sprite_heart_blue;
    g_state = SANS_HEART_STATE_BLUE;
    g_disable = false;
}

void sans_heart_disable(void) {
    g_disable = true;
}

void sans_heart_throw(sans_direction_t direction) {
    switch (direction) {
        case SANS_DIRECTION_UP:
            g_heart_velocity.x = 0;
            g_heart_velocity.y = -G_THROW_SPEED;
            break;
        case SANS_DIRECTION_DOWN:
            g_heart_velocity.x = 0;
            g_heart_velocity.y = G_THROW_SPEED;
            break;
        case SANS_DIRECTION_LEFT:
            g_heart_velocity.x = -G_THROW_SPEED;
            g_heart_velocity.y = 0;
            break;
        case SANS_DIRECTION_RIGHT:
            g_heart_velocity.x = G_THROW_SPEED;
            g_heart_velocity.y = 0;
            break;
    }
}

void sans_heart_set_position(vec24_t position) {
    g_heart_int_position.x = position.x;
    g_heart_position.x = (float)position.x;
    g_heart_int_position.y = position.y;
    g_heart_position.y = (float)position.y;
    g_heart_velocity.x = 0.0;
    g_heart_velocity.y = 0.0;
}

void sans_heart_set_position_default(void) {
    vec24_t position = vec2(G_POSITION_DEFAULT_X, G_POSITION_DEFAULT_Y);
    sans_heart_set_position(position);
}

sans_heart_state_t sans_heart_get_state(void) {
    return g_state;
}
