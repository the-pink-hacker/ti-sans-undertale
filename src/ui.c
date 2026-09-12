#include "ui.h"

#include <fontlibc.h>

#include "color.h"
#include "ui/font.h"
#include "ui/button.h"
#include "ui/health.h"
#include "health.h"

#define _HUD_Y 203

sans_result_t sans_ui_init(void) {
    return sans_ui_font_init();
}

void sans_ui_update(void) {
    sans_ui_health_update();
}

static void _draw_hud_text(void) {
    sans_ui_font_set_color_white();
    sans_ui_font_set_hud();

    fontlib_SetCursorPosition(20, _HUD_Y);
    fontlib_DrawString("CHARA");

    fontlib_SetCursorPosition(65, _HUD_Y);
    fontlib_DrawString("LV 19   HP");

    fontlib_SetCursorPosition(185, _HUD_Y);
    fontlib_DrawString("KR  ");

    if (sans_health_get_kr() > 0) {
        sans_ui_font_set_color_magenta();
    }

    fontlib_DrawUInt(sans_health_get_hp(), 2);
    fontlib_DrawString("/92");
}

void sans_ui_draw(void) {
    _draw_hud_text();

    sans_ui_health_draw();
    sans_ui_button_draw();
}
