#pragma once

#include <stdint.h>

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
