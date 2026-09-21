#include "game.h"

#include "battle.h"
#include "draw.h"
#include "input.h"
#include "heart.h"
#include "ui.h"
#include "character.h"
#include "init.h"
#include "health.h"
#include "entity.h"

static void g_pre_update(void) {
    sans_draw_pre();
    sans_input_update();
}

static void g_update(void) {
    sans_battle_update();
    sans_entity_update();
    sans_health_update();
    sans_heart_update();
    sans_ui_update();
    sans_character_update();
}

static void g_post_update(void) {
    sans_input_post_update();
}

static sans_result_t g_gameloop(void) {
    g_pre_update();

    if (sans_input_pressing_exit()) {
        return SANS_USER_EXIT;
    }

    g_update();
    g_post_update();

    sans_draw();

    return SANS_SUCCESS;
}

sans_result_t sans_game_init(void) {
    EARLY_EXIT(sans_init());

    while (true) {
        EARLY_EXIT(g_gameloop());
    }
}
