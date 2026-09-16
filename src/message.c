#include "message.h"

#include <fontlibc.h>

void sans_message_update(sans_message_state_t *state) {
    if (state->status == SANS_MESSAGE_PRINTING) {
        if (state->advance_in_frames == 0) {
            state->advance_in_frames = state->message->frame_delay;
            state->print_index++;

            // End of string
            if (state->message->text[state->print_index] == 0) {
                state->status = SANS_MESSAGE_PRINTED;
            }
        } else {
            state->advance_in_frames--;
        }
    } else if (sans_input_pressed_enter()) {
        state->status = SANS_MESSAGE_CONTINUE;
    }
}

void sans_message_draw(sans_message_state_t *state) {
    fontlib_HomeUp();
    fontlib_DrawStringL(state->message->text, state->print_index);
}
