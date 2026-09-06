#include "draw.h"

#include <graphx.h>

#include "heart.h"

void sans_draw_pre(void) {
    gfx_SwapDraw();
}

static void _wait_frame(void) {
    // Set screen to visible
    gfx_SetDraw(gfx_screen);
    // Swap to non-visible
    // This is one v-sync
    // The other v-sync happens at the start of the frame
    // This is to force the game to run at 30 fps (2 v-syncs)
    // TODO: Find a better way to do this...
    gfx_SwapDraw();
}

void sans_draw(void) {
    // Empty out the current buffer
    gfx_ZeroScreen();
    _wait_frame();

    sans_heart_draw();
}
