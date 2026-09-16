#pragma once

#include "../message.h"

void sans_ui_speach_box_update(void);

void sans_ui_speach_box_draw(void);

void sans_ui_speach_box_set_message(sans_message_t *message);

bool sans_ui_speach_box_continue(void);
