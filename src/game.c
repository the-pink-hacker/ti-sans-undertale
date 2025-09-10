#include <ti/getcsc.h>

#include "input.h"

static bool sans_gameloop(void) {
    sans_update_input();

    if (sans_should_exit()) {
        return false;
    }

    return true;
}

void sans_game_init(void) {
    while (sans_gameloop());
}
