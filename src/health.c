#include "health.h"

#define _MAX_HEALTH 92

static uint8_t _hp = _MAX_HEALTH - 50;

static uint8_t _kr = 50;
// Number of frames since the last drain
static uint8_t _kr_last_drain = 0;

static void _drain_kr(void) {
    if (_kr >= 40
            || (_kr >= 30 && _kr_last_drain >= 2)
            || (_kr >= 20 && _kr_last_drain >= 5)
            || (_kr >= 10 && _kr_last_drain >= 15)
            || _kr_last_drain >= 30
    ) {
        _kr--;
        _kr_last_drain = 0;
    }
}

void sans_health_update(void) {
    if (_kr > 0) {
        _kr_last_drain++;
        _drain_kr();
    }
}

uint8_t sans_health_get_hp(void) {
    return _hp;
}

float sans_health_get_hp_percent(void) {
    return (float)_hp / (float)_MAX_HEALTH;
}

uint8_t sans_health_get_kr(void) {
    return _kr;
}

float sans_health_get_kr_percent(void) {
    return (float)_kr / (float)_MAX_HEALTH;
}
