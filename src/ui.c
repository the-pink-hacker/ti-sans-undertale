#include "ui.h"

#include <graphx.h>

#include "generated/sprites/ui.h"

#define _attack_box_x 117
#define _attack_box_y 109
#define _attack_box_size 86
#define _attack_box_thickness 3

#define _button_y 214
#define _button_fight_x 15
#define _button_act_x 92
#define _button_item_x 172
#define _button_mercy_x 249

#define white 0b11111111
#define black 0b00000000
#define red 0b11100000
#define green 0b00000111
#define blue 0b00011000
#define yellow red | green
#define cyan green | blue
#define magenta blue | red

void sans_ui_update(void) {}

static void _draw_attack_box(void) {
    gfx_SetColor(white);

    uint24_t x = _attack_box_x;
    uint8_t y = _attack_box_y;
    uint8_t size = _attack_box_size;

    for (uint8_t i = 0; i < _attack_box_thickness; i++) {
        gfx_Rectangle_NoClip(x, y, size, size);
        
        x++;
        y++;
        size -= 2;
    }
}

static void _draw_buttons(void) {
    gfx_Sprite_NoClip(&sprite_button_fight, _button_fight_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_act, _button_act_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_item, _button_item_x, _button_y);
    gfx_Sprite_NoClip(&sprite_button_mercy, _button_mercy_x, _button_y);
}

void sans_ui_draw(void) {
    _draw_buttons();
    _draw_attack_box();
}
