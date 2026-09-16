#include "speach_box.h"

#include <graphx.h>
#include <stdint.h>
#include <fontlibc.h>

#include "font.h"
#include "../vec.h"
#include "../generated/sprites/ui.h"

// Width of the white middle
#define _WIDTH 90
// Height of the white middle
#define _HEIGHT 50
#define _LEFT_WIDTH SPRITE_SPEACH_BOX_LEFT_WIDTH
#define _TEXT_X_PADDING 3
#define _TEXT_X_OFFSET (_LEFT_WIDTH - _TEXT_X_PADDING)
#define _TEXT_WIDTH (_WIDTH + _TEXT_X_PADDING)
#define _TEXT_Y_PADDING 5
#define _TEXT_Y_OFFSET _TEXT_Y_PADDING
#define _TEXT_HEIGHT (_HEIGHT - _TEXT_Y_PADDING)


static sans_message_state_t _state = {
    .message = NULL,
    .status = SANS_MESSAGE_CONTINUE,
    .print_index = 0,
    .advance_in_frames = 0,
};

void sans_ui_speach_box_update(void) {
    if (_state.message == NULL) {
        return;
    }

    if (_state.status == SANS_MESSAGE_CONTINUE) {
        _state.message = NULL;
    }

    sans_message_update(&_state);
}

static void _draw_box(vec24_t position) {
    gfx_Sprite_NoClip(
        &sprite_speach_box_left,
        position.x,
        position.y
    );
    gfx_Sprite_NoClip(
        &sprite_speach_box_right,
        position.x + _LEFT_WIDTH + _WIDTH,
        position.y
    );
    gfx_FillRectangle_NoClip(
        position.x + _LEFT_WIDTH,
        position.y,
        _WIDTH,
        _HEIGHT
    );

    fontlib_SetWindow(
        position.x + _TEXT_X_OFFSET,
        position.y + _TEXT_Y_OFFSET,
        _TEXT_WIDTH,
        _TEXT_HEIGHT
    );
    sans_message_draw(&_state);
}

void sans_ui_speach_box_draw(void) {
    if (_state.message == NULL) {
        return;
    }

    sans_ui_font_set_comic();
    sans_ui_font_set_color_black();
    vec24_t position = vec2(195, 35);
    _draw_box(position);
}

void sans_ui_speach_box_set_message(sans_message_t *message) {
    _state.status = SANS_MESSAGE_PRINTING;
    _state.message = message;
}

bool sans_ui_speach_box_continue(void) {
    return _state.message == NULL;
}
