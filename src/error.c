#include <ti/sprintf.h>
#include <ti/screen.h>

#include "error.h"

// TODO: Only add to debug builds

static char sans_error_buffer[64];
static char *sans_error_file;
static uint24_t sans_error_line = -1;

static void _println(char *text) {
    os_PutStrFull(text);
    os_NewLine();
}

void sans_error_print(char *text) {
    _println(text);
    boot_sprintf(
        sans_error_buffer,
        "%s:%u",
        sans_error_file,
        (unsigned int)sans_error_line
    );
    _println(sans_error_buffer);
}

void sans_error_set_file_line(char *file, uint24_t line) {
    sans_error_file = file;
    sans_error_line = line;
}
