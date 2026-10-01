#include "1.h"

#include "../battle.h"
#include "../blaster.h"
#include "../heart.h"
#include "../input.h"
#include "../entity.h"
#include "../warning.h"
#include "../bone/rise.h"
#include "../bone/wave.h"
#include "../ui/box.h"

void sans_attack_1_update(void) {
    // Takes the time mod 256.
    // This attack is less than 256 frames.
    // Meaning a u8 is good enough to fit the time.
    // This lowers the file size
    uint8_t time = (uint8_t)sans_battle_get_time();

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
        case 22:
            sans_warning_enable();
            break;
        case 27:
            sans_warning_disable();
            break;
        case 28:
            sans_bone_rise_spawn_bottom();
            break;
        case 42:
            sans_heart_set_red();
            break;
        case 54:
            sans_bone_wave_spawn();
            break;
        case 71:
            sans_bone_rise_remove_bottom();
            break;
        case 86:
            sans_blaster_spawn_4a();
            break;
        case 106:
            sans_bone_wave_remove();
            break;
        case 111:
            sans_blaster_spawn_4b();
            break;
        case 132:
            //sans_blaster_remove_4a();
            break;
        case 136:
            //sans_blaster_spawn_4a();
            break;
        case 156:
            sans_blaster_remove_4b();
            sans_blaster_spawn_2();
            break;
        case 182:
            //sans_blaster_remove_4a();
            break;
        case 217:
            sans_blaster_remove_2();
            break;
        case 247:
            sans_battle_set_attack(SANS_BATTLE_ATTACK_1_POST);
            break;
    }
}
