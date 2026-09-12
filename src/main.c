#include <ti/getkey.h>

#include "game.h"
#include "init.h"
#include "error.h"

static int sans_handle_errors(sans_result_t result) {
    switch (result) {
        case SANS_SUCCESS:
        case SANS_USER_EXIT:
            return 0;
        case SANS_FONT_MISSING:
            sans_error_print("Font missing");
            break;
        case SANS_FONT_INVALID:
            sans_error_print("Font invalid");
            break;
    }

    while (!os_GetKey());
    return -1;
}

int main(void) {
    sans_result_t result = sans_game_init();
    sans_exit();

    return sans_handle_errors(result);
}
