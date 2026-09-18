#include "1_post.h"

#include "../battle.h"
#include "../ui/speach_box.h"

static sans_message_t g_message = {
    .text = "here we go.",
    .frame_delay = 1,
    .allow_skip = true,
};

void sans_attack_1_post_update(void) {
    if (sans_battle_get_time() == 0) {
        sans_ui_speach_box_set_message(&g_message);
    }

    if (sans_ui_speach_box_continue()) {
        sans_battle_set_attack(SANS_BATTLE_ATTACK_MENU);
    }
}
