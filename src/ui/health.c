#include "health.h"

#include <graphx.h>
#include <stdint.h>
#include <math.h>

#include "../health.h"
#include "../color.h"

#define _BAR_X 128
#define _BAR_Y 200
#define _BAR_WIDTH 55
#define _BAR_HEIGHT 10

static uint8_t _hp_width;
static uint8_t _kr_width;

void sans_ui_health_update(void) {
    // TODO: Cache health values
    _hp_width = lround(sans_health_get_hp_percent() * _BAR_WIDTH);
    _kr_width = lround(sans_health_get_kr_percent() * _BAR_WIDTH);
}

void sans_ui_health_draw(void) {
    if (_hp_width > 0) {
        gfx_SetColor(YELLOW);
        gfx_FillRectangle_NoClip(_BAR_X, _BAR_Y, _hp_width, _BAR_HEIGHT);
    }

    if (_kr_width > 0) {
        gfx_SetColor(MAGENTA);
        gfx_FillRectangle_NoClip(_BAR_X + _hp_width, _BAR_Y, _kr_width, _BAR_HEIGHT);
    }

    uint8_t total = _hp_width + _kr_width;
    uint8_t remaining = _BAR_WIDTH - total;

    if (remaining > 0) {
        gfx_SetColor(RED);
        gfx_FillRectangle_NoClip(_BAR_X + total, _BAR_Y, remaining, _BAR_HEIGHT);
    }
}
