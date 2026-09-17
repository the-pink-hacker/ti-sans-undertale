#pragma once

#include <stdint.h>

typedef enum {
    // The dialog before sans attacks
    SANS_BATTLE_ATTACK_1_PRE,
    SANS_BATTLE_ATTACK_1,
    SANS_BATTLE_ATTACK_1_POST,
} sans_battle_attack_t;

void sans_battle_update(void);

uint24_t sans_battle_get_time(void);

void sans_battle_set_attack(sans_battle_attack_t attack);
