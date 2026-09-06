#include "input.h"

#include <keypadc.h>

#define SANS_KEY_EXIT kb_KeyClear
#define SANS_KEY_LEFT kb_KeyLeft
#define SANS_KEY_RIGHT kb_KeyRight
#define SANS_KEY_UP kb_KeyUp
#define SANS_KEY_DOWN kb_KeyDown
#define SANS_KEY_DEBUG_HEART_RED kb_Key2nd
#define SANS_KEY_DEBUG_HEART_BLUE kb_KeyAlpha

void sans_input_update(void) {
    kb_Scan();
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

bool sans_input_pressing_down(void) {
    return kb_IsDown(SANS_KEY_DOWN);
}

bool sans_input_pressing_debug_heart_red(void) {
    return kb_IsDown(SANS_KEY_DEBUG_HEART_RED);
}

bool sans_input_pressing_debug_heart_blue(void) {
    return kb_IsDown(SANS_KEY_DEBUG_HEART_BLUE);
}
