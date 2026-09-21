#include "entity.h"

#include "stdlib.h"

typedef struct sans_entity sans_entity_t;

struct sans_entity {
    void (*update)(uint8_t);
    void (*draw)(uint8_t);
    sans_entity_t *next;
    uint8_t id;
};

static sans_entity_t *g_first_entity = NULL;

static void g_for_each(void (*callback)(sans_entity_t *)) {
    sans_entity_t *next = g_first_entity;

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
    g_for_each(g_draw);
}

// Returns the pointer to the first null next field
static sans_entity_t **g_find_last(sans_entity_t **entity) {
    sans_entity_t **search_entity = entity;

    while (*search_entity != NULL) {
        search_entity = &(*search_entity)->next;
    }

    return search_entity;
}

static sans_entity_t *g_malloc_entity() {
    // TODO: Handle possible error
    return malloc(sizeof(sans_entity_t));
}

void sans_entity_push(void (*update)(uint8_t), void (*draw)(uint8_t), uint8_t id) {
    sans_entity_t **last = g_find_last(&g_first_entity);

    sans_entity_t *entity = g_malloc_entity();
    *last = entity;
    entity->update = update;
    entity->draw = draw;
    entity->next = NULL;
    entity->id = id;
}

void sans_entity_pop_all(void) {
    while (g_first_entity != NULL) {
        sans_entity_t **search_entity = &g_first_entity;

        while ((*search_entity)->next != NULL) {
            search_entity = &(*search_entity)->next;
        }

        free(*search_entity);
        *search_entity = NULL;
    }
}

void sans_entity_exit(void) {
    sans_entity_pop_all();
}
