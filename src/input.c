#include "input.h"

#include <keypadc.h>

static uint8_t _last[7];

#define _was_down(lkey) \
(_last[((lkey) >> 8) - 1] & (lkey))

void sans_input_update(void) {
    kb_Scan();
}

void sans_input_post_update(void) {
    // TODO: Use memcpy
    for (uint8_t i = 0; i < sizeof(_last); i++) {
        _last[i] = kb_Data[i + 1];
    }
}

bool sans_input_pressing_exit(void) {
    return kb_IsDown(SANS_KEY_EXIT);
}

bool sans_input_pressing_left(void) {
    return kb_IsDown(SANS_KEY_LEFT);
}

bool sans_input_pressing_right(void) {
    return kb_IsDown(SANS_KEY_RIGHT);
}

bool sans_input_pressing_up(void) {
    return kb_IsDown(SANS_KEY_UP);
}

bool sans_input_was_pressing_up(void) {
    return _was_down(SANS_KEY_UP);
}

bool sans_input_pressing_down(void) {
    return kb_IsDown(SANS_KEY_DOWN);
}

bool sans_input_pressing_debug_heart_red(void) {
    return kb_IsDown(SANS_KEY_DEBUG_HEART_RED);
}

bool sans_input_pressing_debug_heart_blue(void) {
    return kb_IsDown(SANS_KEY_DEBUG_HEART_BLUE);
}
