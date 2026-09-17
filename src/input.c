#include "input.h"

#include <keypadc.h>

#define SANS_KEY_EXIT kb_KeyClear
#define SANS_KEY_ENTER kb_KeyEnter
#define SANS_KEY_LEFT kb_KeyLeft
#define SANS_KEY_RIGHT kb_KeyRight
#define SANS_KEY_UP kb_KeyUp
#define SANS_KEY_DOWN kb_KeyDown
#define SANS_KEY_DEBUG_HEART_RED kb_Key2nd
#define SANS_KEY_DEBUG_HEART_BLUE kb_KeyAlpha

static uint8_t g_last[7];
static sans_input_focus_t g_focus = SANS_INPUT_FOCUS_DIALOG;

#define g_was_down(lkey) (g_last[((lkey) >> 8) - 1] & (lkey))
#define g_pressed(lkey) (kb_IsDown(lkey) && !g_was_down(lkey))

void sans_input_update(void) {
    kb_Scan();
}

void sans_input_exit(void) {
    kb_Reset();
}

void sans_input_post_update(void) {
    // TODO: Use memcpy
    for (uint8_t i = 0; i < sizeof(g_last); i++) {
        g_last[i] = kb_Data[i + 1];
    }
}

sans_input_focus_t sans_input_get_focus(void) {
    return g_focus;
}

void sans_input_set_focus(sans_input_focus_t focus) {
    g_focus = focus;
}

bool sans_input_pressing_exit(void) {
    return kb_IsDown(SANS_KEY_EXIT);
}

bool sans_input_pressing_enter(void) {
    return kb_IsDown(SANS_KEY_ENTER);
}

bool sans_input_pressed_enter(void) {
    return g_pressed(SANS_KEY_ENTER);
}

bool sans_input_pressing_left(void) {
    return kb_IsDown(SANS_KEY_LEFT);
}

bool sans_input_pressed_left(void) {
    return g_pressed(SANS_KEY_LEFT);
}

bool sans_input_pressing_right(void) {
    return kb_IsDown(SANS_KEY_RIGHT);
}

bool sans_input_pressed_right(void) {
    return g_pressed(SANS_KEY_RIGHT);
}

bool sans_input_pressing_up(void) {
    return kb_IsDown(SANS_KEY_UP);
}

bool sans_input_was_pressing_up(void) {
    return g_was_down(SANS_KEY_UP);
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
