#include "1.h"

#include <stdint.h>

#include "../battle.h"
#include "../heart.h"
#include "../input.h"
#include "../ui/box.h"

void sans_attack_1_update(void) {
    uint24_t time = sans_battle_get_time();

    switch (time) {
        case 0:
            sans_input_set_focus(SANS_INPUT_FOCUS_NONE);
            sans_heart_set_position_default();
            sans_heart_set_red();
            sans_ui_box_set_size_default();
            break;
        case 8:
            sans_heart_set_blue();
            sans_heart_throw(SANS_DIRECTION_DOWN);
            break;
        case 17:
            sans_input_set_focus(SANS_INPUT_FOCUS_HEART);
            break;
        case 42:
            sans_heart_set_red();
            break;
        case 30 * 7:
            sans_battle_set_attack(SANS_BATTLE_ATTACK_1_POST);
            break;
    }
}
