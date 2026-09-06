#include "game.h"

#include "draw.h"
#include "input.h"
#include "heart.h"
#include "ui.h"

static bool _gameloop(void) {
    sans_draw_pre();
    sans_input_update();

    if (sans_input_pressing_exit()) {
        return false;
    }

    sans_heart_update();
    sans_ui_update();

    sans_draw();

    return true;
}

void sans_game_init(void) {
    while (_gameloop());
}
