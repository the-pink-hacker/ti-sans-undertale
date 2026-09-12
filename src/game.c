#include "game.h"

#include "draw.h"
#include "input.h"
#include "heart.h"
#include "ui.h"
#include "attack_box.h"
#include "character.h"
#include "timer.h"
#include "init.h"
#include "health.h"

static void _update(void) {
    sans_timer_update();
    sans_health_update();
    sans_attack_box_update();
    sans_heart_update();
    sans_ui_update();
    sans_character_update();
}

static void _post_update(void) {
    sans_input_post_update();
}

static sans_result_t _gameloop(void) {
    sans_draw_pre();

    sans_input_update();

    if (sans_input_pressing_exit()) {
        return SANS_USER_EXIT;
    }

    _update();
    _post_update();

    sans_draw();

    return SANS_SUCCESS;
}

sans_result_t sans_game_init(void) {
    EARLY_EXIT(sans_init());

    while (true) {
        EARLY_EXIT(_gameloop());
    }
}
