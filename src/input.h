#pragma once

typedef enum __attribute__((packed)) {
    // Player input does nothing
    SANS_INPUT_FOCUS_NONE,
    // The bottom buttons
    SANS_INPUT_FOCUS_BUTTON,
    // The soul
    SANS_INPUT_FOCUS_HEART,
    // The speach box
    SANS_INPUT_FOCUS_DIALOG
} sans_input_focus_t;

// Update the keyboard values
// Called at the start of the frame
void sans_input_update(void);

void sans_input_exit(void);

void sans_input_post_update(void);

void sans_input_set_focus(sans_input_focus_t focus);

sans_input_focus_t sans_input_get_focus(void);

// Has the user requested to exit
bool sans_input_pressing_exit(void);

bool sans_input_pressing_enter(void);
bool sans_input_pressed_enter(void);

bool sans_input_pressing_left(void);
bool sans_input_pressed_left(void);
bool sans_input_pressing_right(void);
bool sans_input_pressed_right(void);
bool sans_input_pressing_up(void);
bool sans_input_was_pressing_up(void);
bool sans_input_pressing_down(void);

bool sans_input_pressing_debug_heart_red(void);
bool sans_input_pressing_debug_heart_blue(void);
