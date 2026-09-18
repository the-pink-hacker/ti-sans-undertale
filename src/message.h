#pragma once

#include <stdint.h>

#include "input.h"

typedef enum __attribute__((packed)) {
    // Message is currently being printed
    SANS_MESSAGE_PRINTING,
    // Message is done being printed
    SANS_MESSAGE_PRINTED,
    // User has continued
    SANS_MESSAGE_CONTINUE,
} sans_message_status_t;

typedef struct {
    const char *text;
    bool allow_skip;
    uint8_t frame_delay;
} sans_message_t;

typedef struct {
    sans_message_t *message;
    sans_message_status_t status;
    uint8_t print_index;
    uint8_t advance_in_frames;
} sans_message_state_t;

void sans_message_update(sans_message_state_t *state);

void sans_message_draw(sans_message_state_t *state);
