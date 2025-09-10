#include <keypadc.h>

#define SANS_KEY_EXIT kb_KeyClear

void sans_update_input(void) {
    kb_Scan();
}

bool sans_should_exit(void) {
    return kb_IsDown(SANS_KEY_EXIT);
}
