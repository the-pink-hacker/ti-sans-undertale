#include "1_pre.h"

#include "../battle.h"
#include "../ui/box.h"
#include "../ui/speach_box.h"
#include "../heart.h"

static sans_message_t g_message = {
    .text = "ready?",
    .focus = SANS_INPUT_FOCUS_DIALOG,
    .frame_delay = 1,
    .allow_skip = true,
};

void sans_battle_1_pre_update(void) {
    if (sans_battle_get_time() == 0) {
        sans_ui_box_disable();
        sans_heart_disable();
        sans_ui_speach_box_set_message(&g_message);
    }

    if (sans_ui_speach_box_continue()) {
        sans_battle_set_attack(SANS_BATTLE_ATTACK_1);
    }
}
