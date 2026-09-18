#include "menu.h"

#include "../battle.h"
#include "../heart.h"
#include "../input.h"
#include "../ui/box.h"

void sans_attack_menu_update(void) {
    if (sans_battle_get_time() == 0) {
        sans_heart_disable();
        sans_ui_box_transition_wide();
        sans_input_set_focus(SANS_INPUT_FOCUS_BUTTON);
    }
}
