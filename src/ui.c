#include "ui.h"

#include <fontlibc.h>
#include <graphx.h>

#include "color.h"
#include "ui/font.h"
#include "ui/button.h"
#include "ui/health.h"
#include "ui/speach_box.h"
#include "ui/box.h"
#include "health.h"

#define G_HUD_Y 203

sans_result_t sans_ui_init(void) {
    return sans_ui_font_init();
}

void sans_ui_update(void) {
    sans_ui_health_update();
    sans_ui_button_update();
    sans_ui_speach_box_update();
}

static void g_draw_hud_text(void) {
    sans_ui_font_set_color_white();
    sans_ui_font_set_hud();

    fontlib_SetCursorPosition(20, G_HUD_Y);
    fontlib_DrawString("CHARA");

    fontlib_SetCursorPosition(65, G_HUD_Y);
    fontlib_DrawString("LV 19   HP");

    fontlib_SetCursorPosition(185, G_HUD_Y);
    fontlib_DrawString("KR  ");

    if (sans_health_get_kr() > 0) {
        sans_ui_font_set_color_magenta();
    }

    fontlib_DrawUInt(sans_health_get_hp(), 2);
    fontlib_DrawString("/92");
}

void sans_ui_draw(void) {
    gfx_SetColor(SANS_COLOR_WHITE);
    sans_ui_box_draw();
    sans_ui_speach_box_draw();

    fontlib_SetWindowFullScreen();
    g_draw_hud_text();

    sans_ui_health_draw();
    sans_ui_button_draw();
}
