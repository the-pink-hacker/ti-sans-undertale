#include "game.h"

#include "draw.h"
#include "input.h"
#include "heart.h"
#include "ui.h"
#include "attack_box.h"
#include "character.h"

static bool _gameloop(void) {
    sans_draw_pre();
    sans_input_update();

    if (sans_input_pressing_exit()) {
        return false;
    }

    sans_attack_box_update();
    sans_heart_update();
    sans_ui_update();
    sans_character_update();

    sans_draw();

    return true;
}

void sans_game_init(void) {
    while (_gameloop());
}
