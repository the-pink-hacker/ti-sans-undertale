#include "bone.h"

#include "generated/sprites.h"

void sans_bone_draw_top(vec24_t position, uint8_t height) {
    // Top
    gfx_TransparentSprite_NoClip(
        &SPRITE_BONE_TOP,
        position.x,
        position.y - height - SPRITE_BONE_TOP_HEIGHT
    );
    // Middle
    gfx_FillRectangle_NoClip(
        position.x + 1,
        position.y - height,
        3,
        height
    );
}

void sans_bone_draw_clip(vec24i_t position, uint8_t height) {
    // Bottom
    gfx_TransparentSprite(
        &SPRITE_BONE_BOTTOM,
        position.x,
        position.y - (SPRITE_BONE_BOTTOM_HEIGHT)
    );
    // Top
    gfx_TransparentSprite(
        &SPRITE_BONE_TOP,
        position.x,
        position.y - height - (SPRITE_BONE_TOP_HEIGHT * 2)
    );
    // Middle
    gfx_FillRectangle(
        position.x + 1,
        position.y - height - SPRITE_BONE_BOTTOM_HEIGHT,
        3,
        height
    );
}
