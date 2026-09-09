#include "timer.h"

static uint24_t _frame = 0;

void sans_timer_update(void) {
    _frame++;
}

uint24_t sans_timer_frame(void) {
    return _frame;
}
