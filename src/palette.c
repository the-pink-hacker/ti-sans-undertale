#include "palette.h"

#include <graphx.h>

#include "generated/palette.h"


static void g_set_single(uint8_t index, uint16_t color) {
    gfx_SetPalette(&color, 2, index);
}

void sans_palette_init(void) {
    gfx_SetPalette(&PALETTE_TABLE, PALETTE_SIZE, 0);
}

void sans_palette_set_soul_red(void) {
    g_set_single(PALETTE_RESERVE_SOUL, gfx_RGBTo1555(255, 0, 0));
}

void sans_palette_set_soul_blue(void) {
    g_set_single(PALETTE_RESERVE_SOUL, gfx_RGBTo1555(0, 60, 255));
}
