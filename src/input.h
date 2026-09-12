#define SANS_KEY_EXIT kb_KeyClear
#define SANS_KEY_LEFT kb_KeyLeft
#define SANS_KEY_RIGHT kb_KeyRight
#define SANS_KEY_UP kb_KeyUp
#define SANS_KEY_DOWN kb_KeyDown
#define SANS_KEY_DEBUG_HEART_RED kb_Key2nd
#define SANS_KEY_DEBUG_HEART_BLUE kb_KeyAlpha

// Update the keyboard values
// Called at the start of the frame
void sans_input_update(void);

void sans_input_exit(void);

void sans_input_post_update(void);

// Has the user requested to exit
bool sans_input_pressing_exit(void);

bool sans_input_pressing_left(void);
bool sans_input_pressing_right(void);
bool sans_input_pressing_up(void);
bool sans_input_was_pressing_up(void);
bool sans_input_pressing_down(void);

bool sans_input_pressing_debug_heart_red(void);
bool sans_input_pressing_debug_heart_blue(void);
