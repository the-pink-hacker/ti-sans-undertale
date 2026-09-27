#include "entity.h"

#include <stdlib.h>
#include <graphx.h>

#include "color.h"

typedef struct sans_entity sans_entity_t;

struct sans_entity {
    void (*update)(uint8_t);
    void (*draw)(uint8_t);
    sans_entity_t *next;
    sans_entity_t *prev;
    uint8_t id;
};

static sans_entity_t *g_first = NULL;
static sans_entity_t *g_last = NULL;

static void g_for_each(void (*callback)(sans_entity_t *)) {
    sans_entity_t *next = g_first;

    while(next != NULL) {
        callback(next);
        next = next->next;
    }
}

static void g_update(sans_entity_t *entity) {
    entity->update(entity->id);
}

void sans_entity_update(void) {
    g_for_each(g_update);
}

static void g_draw(sans_entity_t *entity) {
    entity->draw(entity->id);
}

void sans_entity_draw(void) {
    // Most entities are white
    gfx_SetColor(SANS_COLOR_WHITE);
    g_for_each(g_draw);
}

static sans_entity_t *g_malloc_entity() {
    // TODO: Handle possible error
    return malloc(sizeof(sans_entity_t));
}

sans_entity_handle_t sans_entity_push(
    void (*update)(uint8_t),
    void (*draw)(uint8_t),
    uint8_t id
) {
    sans_entity_t *entity = g_malloc_entity();
    entity->update = update;
    entity->draw = draw;
    entity->id = id;
    sans_entity_handle_t handle = {
        .g_value = (void *)entity,
    };

    if (g_first == NULL) {
        entity->prev = NULL;
        g_first = entity;
    } else {
        entity->prev = g_last;
        g_last->next = entity;
    }

    entity->next = NULL;

    g_last = entity;
    return handle;
}

static void g_free_entity(sans_entity_t *entity) {
    free(entity);
}

void sans_entity_pop_all(void) {
    g_for_each(g_free_entity);
    g_first = NULL;
    g_last = NULL;
}

void sans_entity_remove(sans_entity_handle_t handle) {
    sans_entity_t *entity = (sans_entity_t *)handle.g_value;

    // Entity was the last
    if (entity == g_last) {
        g_last = entity->prev;
    } else {
        entity->next->prev = entity->prev;
    }

    // Entity was the first
    if (entity == g_first) {
        g_first = entity->next;
    } else {
        entity->prev->next = entity->next;
    }

    free(entity);
}

void sans_entity_exit(void) {
    sans_entity_pop_all();
}
