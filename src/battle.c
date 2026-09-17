#include "battle.h"

#include "attack.h"

sans_battle_attack_t g_attack = SANS_BATTLE_ATTACK_1_PRE;
uint24_t g_time = 0;

void sans_battle_update(void) {
    switch (g_attack) {
        case SANS_BATTLE_ATTACK_1_PRE:
            sans_battle_1_pre_update();
            break;
        case SANS_BATTLE_ATTACK_1:
            sans_battle_1_update();
            break;
        case SANS_BATTLE_ATTACK_1_POST:
            sans_battle_1_post_update();
            break;
    }

    g_time++;
}

uint24_t sans_battle_get_time(void) {
    return g_time;
}

void sans_battle_set_attack(sans_battle_attack_t attack) {
    g_attack = attack;
    g_time = -1;
}
