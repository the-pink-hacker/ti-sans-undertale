#include "font.h"

#include <stdint.h>
#include <fileioc.h>
#include <fontlibc.h>

#include "../color.h"
#include "../error.h"

static fontlib_font_t *_hud;
static fontlib_font_t *_comic;

static sans_result_t _get_font(const fontlib_font_pack_t *font_pack, uint8_t index, fontlib_font_t **font) {
    fontlib_font_t *new_font = fontlib_GetFontByIndexRaw(font_pack, index);

    if (new_font == NULL) {
        RETURN_ERROR(SANS_FONT_INVALID);
    }

    *font = new_font;

    return SANS_SUCCESS;
}

static sans_result_t _load_file(void) {
    uint8_t file = ti_Open("SANSFNT", "r");

    if (file == 0) {
        RETURN_ERROR(SANS_FONT_MISSING);
    }

    fontlib_font_pack_t *font_pack = ti_GetDataPtr(file);
    ti_Close(file);

    EARLY_EXIT(_get_font(font_pack, 0, &_comic));
    EARLY_EXIT(_get_font(font_pack, 1, &_hud));

    return SANS_SUCCESS;
}

sans_result_t sans_ui_font_init(void) {
    EARLY_EXIT(_load_file());
    fontlib_SetNewlineOptions(FONTLIB_ENABLE_AUTO_WRAP);
    fontlib_SetTransparency(true);
    fontlib_SetWindowFullScreen();

    return SANS_SUCCESS;
}

void sans_ui_font_set_color_black(void) {
    fontlib_SetForegroundColor(BLACK);
}

void sans_ui_font_set_color_white(void) {
    fontlib_SetForegroundColor(WHITE);
}

void sans_ui_font_set_color_magenta(void) {
    fontlib_SetForegroundColor(MAGENTA);
}

static void _set_font(const fontlib_font_t *font) {
    fontlib_LoadFont(font, 0);
}

void sans_ui_font_set_comic(void) {
    _set_font(_comic);
}

void sans_ui_font_set_hud(void) {
    _set_font(_hud);
}
