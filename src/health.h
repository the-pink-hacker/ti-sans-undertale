#pragma once

#include <stdint.h>

void sans_health_update(void);

uint8_t sans_health_get_hp(void);

float sans_health_get_hp_percent(void);

uint8_t sans_health_get_kr(void);

float sans_health_get_kr_percent(void);

// Applies 1 hp of damage
void sans_health_damage(void);

void sans_health_add_kr(uint8_t amount);
