#include "health.h"

#include <graphx.h>
#include <stdint.h>
#include <math.h>

#include "../health.h"
#include "../color.h"

#define G_BAR_X 128
#define G_BAR_Y 200
#define G_BAR_WIDTH 55
#define G_BAR_HEIGHT 10

static uint8_t g_hp_width;
static uint8_t g_kr_width;

void sans_ui_health_update(void) {
    // TODO: Cache health values
    g_hp_width = lround(sans_health_get_hp_percent() * G_BAR_WIDTH);
    g_kr_width = lround(sans_health_get_kr_percent() * G_BAR_WIDTH);
}

void sans_ui_health_draw(void) {
    if (g_hp_width > 0) {
        gfx_SetColor(SANS_COLOR_YELLOW);
        gfx_FillRectangle_NoClip(G_BAR_X, G_BAR_Y, g_hp_width, G_BAR_HEIGHT);
    }

    if (g_kr_width > 0) {
        gfx_SetColor(SANS_COLOR_MAGENTA);
        gfx_FillRectangle_NoClip(G_BAR_X + g_hp_width, G_BAR_Y, g_kr_width, G_BAR_HEIGHT);
    }

    uint8_t total = g_hp_width + g_kr_width;
    uint8_t remaining = G_BAR_WIDTH - total;

    if (remaining > 0) {
        gfx_SetColor(SANS_COLOR_RED);
        gfx_FillRectangle_NoClip(G_BAR_X + total, G_BAR_Y, remaining, G_BAR_HEIGHT);
    }
}
