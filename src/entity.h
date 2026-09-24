#pragma once

#include <stdint.h>

typedef struct {
    void **g_value;
} sans_entity_handle_t;

void sans_entity_exit(void);

void sans_entity_update(void);

void sans_entity_draw(void);

sans_entity_handle_t sans_entity_push(
    void (*update)(uint8_t),
    void (*draw)(uint8_t),
    uint8_t id
);

void sans_entity_pop_all(void);

void sans_entity_remove(sans_entity_handle_t handle);
