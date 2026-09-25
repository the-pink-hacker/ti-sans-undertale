#include "debug.h"

#include <string.h>
#include <stdint.h>

char *G_CONSOLE = (char *)0xfb0000;
uint8_t *G_MAX = (uint8_t *)0xffffff;

void sans_debug_cemu_console_print(const char *text) {
    strcpy(G_CONSOLE, text);
}

void sans_debug_cemu_open_debugger(void) {
    *G_MAX = 2;
}
