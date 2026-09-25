#pragma once

#include "vec.h"

#define SANS_PHYSCIS_LIST_LENGTH 255

typedef enum __attribute__((packed)) {
    SANS_PHYSCIS_DAMAGE_BONE_LOOP,
    SANS_PHYSCIS_DAMAGE_BLASTER,
    SANS_PHYSCIS_DAMAGE_BONE_MENU_TOP,
    SANS_PHYSCIS_DAMAGE_BONE_MENU_BOTTOM,
    SANS_PHYSCIS_DAMAGE_MISC,
} sans_physics_damage_t;

typedef enum __attribute__((packed)) {
    // All space below and equal to the y value
    SANS_PHYSCIS_SHAPE_Y_DOWN,
} sans_physics_shape_type_t;

typedef union {
    struct {
        uint8_t *y;
    } plane_horizontal;
} sans_physics_shape_value_t;

typedef struct {
    uint8_t id;
    // Collided last frame
    bool collided;
    sans_physics_damage_t damage;
    sans_physics_shape_type_t shape;
    sans_physics_shape_value_t value;
} sans_physics_list_element_t;

typedef struct {
    uint8_t count;
    sans_physics_list_element_t elements[SANS_PHYSCIS_LIST_LENGTH];
} sans_physics_list_t;

// Is fully within a box
// Returns true if position was changed
void sans_physics_clamp_within_box(
    vec24_t *position,
    vec2_t size,
    vec24_t box_position,
    vec24_t box_size,
    bool *grounded
);

uint8_t sans_physics_list_push_y_down(uint8_t *y);

sans_physics_list_t *sans_physics_get_list(void);

// Linear time
void sans_physics_list_remove(uint8_t id);

// Constant time
void sans_physics_list_reset(void);
