#include "button.h"

#include <graphx.h>

#define _BUTTON_Y 214
#define _BUTTON_FIGHT_X 15
#define _BUTTON_ACT_X 92
#define _BUTTON_ITEM_X 172
#define _BUTTON_MERCY_X 249

#include "generated/sprites/ui.h"

void sans_ui_button_draw(void) {
    gfx_Sprite_NoClip(&sprite_button_fight, _BUTTON_FIGHT_X, _BUTTON_Y);
    gfx_Sprite_NoClip(&sprite_button_act, _BUTTON_ACT_X, _BUTTON_Y);
    gfx_Sprite_NoClip(&sprite_button_item, _BUTTON_ITEM_X, _BUTTON_Y);
    gfx_Sprite_NoClip(&sprite_button_mercy, _BUTTON_MERCY_X, _BUTTON_Y);
}
