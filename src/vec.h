#pragma once

#include <stdint.h>

#define vec2(x_val, y_val) {.x = x_val, .y = y_val}
#define vec2_splat(val) vec2(val, val)

// A 2d vector with a 24-bit x and 8-bit y
typedef struct {
    uint24_t x;
    uint8_t y;
} vec24_t;

// A 2d 8-bit vector
typedef struct {
    uint8_t x;
    uint8_t y;
} vec2_t;

// A 2d floating point vector
typedef struct {
    float x;
    float y;
} vec2f_t;

typedef struct {
    int24_t x;
    uint8_t y;
} vec24i_t;
