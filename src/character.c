#include "character.h"

#include <graphx.h>

#include "generated/sprites/sans.h"

#define G_X 134
#define G_Y 31

void sans_character_update(void) {}

void sans_character_draw(void) {
    gfx_Sprite_NoClip(&sprite_sans, G_X, G_Y);
}
