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

static char *_text = "ready?";

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
    fontlib_HomeUp();
    fontlib_DrawString(_text);
}

void sans_ui_speach_box_draw(void) {
    sans_ui_font_set_comic();
    sans_ui_font_set_color_black();
    vec24_t position = vec2(195, 35);
    _draw_box(position);
}
