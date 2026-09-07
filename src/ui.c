#include "ui.h"

#include <graphx.h>

#include "generated/sprites/ui.h"
#include "color.h"

#define _button_y 214
#define _button_fight_x 15
#define _button_act_x 92
#define _button_item_x 172
#define _button_mercy_x 249

void sans_ui_update(void) {}

static void _draw_buttons(void) {
    gfx_Sprite_NoClip(&sprite_button_fight, _button_fight_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_act, _button_act_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_item, _button_item_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_mercy, _button_mercy_x, _button_y);
}

void sans_ui_draw(void) {
    _draw_buttons();
}
