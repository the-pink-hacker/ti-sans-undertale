#include "character.h"

#include <graphx.h>

#include "generated/sprites/sans.h"

#define _X 134
#define _Y 31

void sans_character_update(void) {}

void sans_character_draw(void) {
    gfx_Sprite_NoClip(&sprite_sans, _X, _Y);
}
