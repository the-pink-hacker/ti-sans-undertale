#include <ti/getcsc.h>

void sans_game_init(void) {
    while (!os_GetCSC());
}
