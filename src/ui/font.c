#include "font.h"

#include <stdint.h>
#include <fileioc.h>
#include <fontlibc.h>

#include "../color.h"
#include "../error.h"

static fontlib_font_t *g_hud;
static fontlib_font_t *g_comic;
static fontlib_font_t *g_button;

static sans_result_t g_get_font(const fontlib_font_pack_t *font_pack, uint8_t index, fontlib_font_t **font) {
    fontlib_font_t *new_font = fontlib_GetFontByIndexRaw(font_pack, index);

    if (new_font == NULL) {
        RETURN_ERROR(SANS_FONT_INVALID);
    }

    *font = new_font;

    return SANS_SUCCESS;
}

static sans_result_t g_load_file(void) {
    uint8_t file = ti_Open("SANSFNT", "r");

    if (file == 0) {
        RETURN_ERROR(SANS_FONT_MISSING);
    }

    fontlib_font_pack_t *font_pack = ti_GetDataPtr(file);
    ti_Close(file);

    EARLY_EXIT(g_get_font(font_pack, 0, &g_comic));
    EARLY_EXIT(g_get_font(font_pack, 1, &g_hud));
    EARLY_EXIT(g_get_font(font_pack, 2, &g_button));

    return SANS_SUCCESS;
}

sans_result_t sans_ui_font_init(void) {
    EARLY_EXIT(g_load_file());
    fontlib_SetNewlineOptions(FONTLIB_ENABLE_AUTO_WRAP);
    fontlib_SetTransparency(true);

    return SANS_SUCCESS;
}

void sans_ui_font_set_color_black(void) {
    fontlib_SetForegroundColor(SANS_COLOR_BLACK);
}

void sans_ui_font_set_color_white(void) {
    fontlib_SetForegroundColor(SANS_COLOR_WHITE);
}

void sans_ui_font_set_color_magenta(void) {
    fontlib_SetForegroundColor(SANS_COLOR_MAGENTA);
}

void sans_ui_font_set_color_orange(void) {
    fontlib_SetForegroundColor(SANS_COLOR_ORANGE);
}

void sans_ui_font_set_color_yellow(void) {
    fontlib_SetForegroundColor(SANS_COLOR_YELLOW);
}

static void g_set_font(const fontlib_font_t *font) {
    fontlib_LoadFont(font, 0);
}

void sans_ui_font_set_comic(void) {
    g_set_font(g_comic);
}

void sans_ui_font_set_hud(void) {
    g_set_font(g_hud);
}

void sans_ui_font_set_button(void) {
    g_set_font(g_button);
}
