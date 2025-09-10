#include <graphx.h>

void sans_draw_pre(void) {
    gfx_SwapDraw();
}

uint8_t test = 0;

static void sans_draw_wait_frame() {
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
    //gfx_ZeroScreen();
    gfx_FillScreen(test);
    test++;
    sans_draw_wait_frame();
}
