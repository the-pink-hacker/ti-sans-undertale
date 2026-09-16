#include "battle.h"

#include "attack.h"

sans_battle_attack_t _attack = SANS_BATTLE_ATTACK_1_PRE;
uint24_t _time = 0;

void sans_battle_update(void) {
    switch (_attack) {
        case SANS_BATTLE_ATTACK_1_PRE:
            sans_battle_1_pre_update();
            break;
        case SANS_BATTLE_ATTACK_1_THROW:
            break;
    }

    _time++;
}

uint24_t sans_battle_get_time(void) {
    return _time;
}

void sans_battle_set_attack(sans_battle_attack_t attack) {
    _attack = attack;
}
