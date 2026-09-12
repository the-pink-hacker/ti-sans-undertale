#include "ui.h"

#include <graphx.h>
#include <fontlibc.h>

#include "generated/sprites/ui.h"
#include "color.h"
#include "ui/font.h"

#define _button_y 214
#define _button_fight_x 15
#define _button_act_x 92
#define _button_item_x 172
#define _button_mercy_x 249

sans_result_t sans_ui_init(void) {
    return sans_ui_font_init();
}

void sans_ui_update(void) {
}

static void _draw_buttons(void) {
    gfx_Sprite_NoClip(&sprite_button_fight, _button_fight_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_act, _button_act_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_item, _button_item_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_mercy, _button_mercy_x, _button_y);
}

void sans_ui_draw(void) {
    _draw_buttons();

    fontlib_SetWindowFullScreen();
    fontlib_HomeUp();
    sans_ui_font_set_color_white();
    sans_ui_font_set_hud();
    fontlib_DrawString("THIS IS A TEST\n");
    fontlib_DrawString("HERE IS THE 2ND LINE\n");
    sans_ui_font_set_comic();
    fontlib_DrawString("this is a test\n");
    fontlib_DrawString("wWmM");
}
