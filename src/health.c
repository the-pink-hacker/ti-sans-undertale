#include "health.h"

#define G_MAX_HEALTH 92
#define G_MAX_KARMA 40

static uint8_t g_hp = G_MAX_HEALTH;

static uint8_t g_kr = 0;
// Number of frames since the last drain
static uint8_t g_kr_last_drain = 0;

static void g_drain_kr(void) {
    if (g_kr >= 40
            || (g_kr >= 30 && g_kr_last_drain >= 2)
            || (g_kr >= 20 && g_kr_last_drain >= 5)
            || (g_kr >= 10 && g_kr_last_drain >= 15)
            || g_kr_last_drain >= 30
    ) {
        g_kr--;
        g_kr_last_drain = 0;
    }
}

void sans_health_update(void) {
    if (g_kr > 0) {
        g_kr_last_drain++;
        g_drain_kr();
    }
}

uint8_t sans_health_get_hp(void) {
    return g_hp;
}

float sans_health_get_hp_percent(void) {
    return (float)g_hp / (float)G_MAX_HEALTH;
}

uint8_t sans_health_get_kr(void) {
    return g_kr;
}

float sans_health_get_kr_percent(void) {
    return (float)g_kr / (float)G_MAX_HEALTH;
}

void sans_health_damage(void) {
    if (g_hp > 0) {
        g_hp--;
    }

    if (g_hp == 0) {
        // DEBUG: Keep player alive
        g_hp = 1;
    }
}

void sans_health_add_kr(uint8_t amount) {
    uint8_t kr_max_increase = G_MAX_KARMA - g_kr;
    uint8_t kr_increase = 0;

    // Clamp karma increase
    if (amount > kr_max_increase) {
        kr_increase = kr_max_increase;
    } else {
        kr_increase = amount;
    }

    // Keep health above 1
    if (g_hp <= kr_increase) {
        g_kr += g_hp - 1;
        g_hp = 1;
    } else {
        g_kr += kr_increase;
        g_hp -= kr_increase;
    }
}
