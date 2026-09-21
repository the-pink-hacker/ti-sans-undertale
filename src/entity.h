#pragma once

#include <stdint.h>

void sans_entity_exit(void);

void sans_entity_update(void);

void sans_entity_draw(void);

void sans_entity_push(void (*update)(uint8_t), void (*draw)(uint8_t), uint8_t id);

void sans_entity_pop_all(void);

