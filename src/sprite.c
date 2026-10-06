#include "sprite.h"

#define G_RUN_LENGTH_MASK 0b10000000
#define G_RUN_LENGTH_MASK_INV (G_RUN_LENGTH_MASK ^ -1)
#define G_TRANSPARENT 0

void sans_sprite_run_length_draw(const gfx_sprite_t *sprite, vec2i_t position) {
    // TODO: Add clipping
    uint24_t new_line_amount = GFX_LCD_WIDTH - (uint8_t)sprite->width;
    const uint8_t *data = &sprite->data[0];
    uint8_t *vram = &gfx_vbuffer[position.y][position.x];

    for (uint8_t y = 0; y < (uint8_t)sprite->height; y++) {
        while (true) {
            uint8_t current = *data;

            if ((current & G_RUN_LENGTH_MASK) == 0) {
                if (current != G_TRANSPARENT) {
                    *vram = current;
                }

                vram++;
                data++;
            } else if (current != 0xff) {
                uint8_t length = (current & G_RUN_LENGTH_MASK_INV) + 1;
                uint8_t color = *(data + 1);
                
                if (color != G_TRANSPARENT) {
                    for (uint8_t i = 0; i < length; i++) {
                        *vram = color;
                        vram++;
                    }
                } else {
                    vram += length;
                }

                data += 2;
            } else {
                vram += new_line_amount;
                data++;
                break;
            }
        }
    }
}
