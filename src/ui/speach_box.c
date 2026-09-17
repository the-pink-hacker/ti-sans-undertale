#include "speach_box.h"

#include <graphx.h>
#include <stdint.h>
#include <fontlibc.h>

#include "font.h"
#include "../vec.h"
#include "../generated/sprites/ui.h"

// Width of the white middle
#define G_WIDTH 90
// Height of the white middle
#define G_HEIGHT 50
#define G_LEFT_WIDTH SPRITE_SPEACH_BOX_LEFT_WIDTH
#define G_TEXT_X_PADDING 3
#define G_TEXT_X_OFFSET (G_LEFT_WIDTH - G_TEXT_X_PADDING)
#define G_TEXT_WIDTH (G_WIDTH + G_TEXT_X_PADDING)
#define G_TEXT_Y_PADDING 5
#define G_TEXT_Y_OFFSET G_TEXT_Y_PADDING
#define G_TEXT_HEIGHT (G_HEIGHT - G_TEXT_Y_PADDING)


static sans_message_state_t g_state = {
    .message = NULL,
    .status = SANS_MESSAGE_CONTINUE,
    .print_index = 0,
    .advance_in_frames = 0,
};

void sans_ui_speach_box_update(void) {
    if (g_state.message == NULL) {
        return;
    }

    if (g_state.status == SANS_MESSAGE_CONTINUE) {
        g_state.message = NULL;
    }

    sans_message_update(&g_state);
}

static void g_draw_box(vec24_t position) {
    gfx_Sprite_NoClip(
        &sprite_speach_box_left,
        position.x,
        position.y
    );
    gfx_Sprite_NoClip(
        &sprite_speach_box_right,
        position.x + G_LEFT_WIDTH + G_WIDTH,
        position.y
    );
    gfx_FillRectangle_NoClip(
        position.x + G_LEFT_WIDTH,
        position.y,
        G_WIDTH,
        G_HEIGHT
    );

    fontlib_SetWindow(
        position.x + G_TEXT_X_OFFSET,
        position.y + G_TEXT_Y_OFFSET,
        G_TEXT_WIDTH,
        G_TEXT_HEIGHT
    );
    sans_message_draw(&g_state);
}

void sans_ui_speach_box_draw(void) {
    if (g_state.message == NULL) {
        return;
    }

    sans_ui_font_set_comic();
    sans_ui_font_set_color_black();
    vec24_t position = vec2(195, 35);
    g_draw_box(position);
}

void sans_ui_speach_box_set_message(sans_message_t *message) {
    g_state.status = SANS_MESSAGE_PRINTING;
    g_state.message = message;
}

bool sans_ui_speach_box_continue(void) {
    return g_state.message == NULL;
}
