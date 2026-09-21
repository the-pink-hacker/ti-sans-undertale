#include "warning.h"

#include <graphx.h>

#include "color.h"

#define G_HEIGHT 27

static bool g_enabled = false;

void sans_warning_draw(void) {
    if (!g_enabled) {
        return;
    }

    gfx_SetColor(SANS_COLOR_RED);
    gfx_Rectangle_NoClip(123, 191 - G_HEIGHT, 76, G_HEIGHT);
}

void sans_warning_enable(void) {
    g_enabled = true;
}

void sans_warning_disable(void) {
    g_enabled = false;
}
