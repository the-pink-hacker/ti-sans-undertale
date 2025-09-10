#include "draw.h"
#include "input.h"

static bool sans_gameloop(void) {
    sans_draw_pre();
    sans_update_input();

    if (sans_should_exit()) {
        return false;
    }

    sans_draw();

    return true;
}

void sans_game_init(void) {
    while (sans_gameloop());
}
