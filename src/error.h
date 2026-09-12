#pragma once

#include <stdint.h>

typedef enum [[nodiscard]] {
    SANS_SUCCESS = 0,
    SANS_USER_EXIT,
    SANS_FONT_MISSING,
    SANS_FONT_INVALID,
} sans_result_t;

void sans_error_print(char *text);

void sans_error_set_file_line(char *file, uint24_t line);

// Continues if success, else returns.
#define EARLY_EXIT(a) ({\
    sans_result_t result = a;\
    if (result != SANS_SUCCESS) {\
        return result;\
    }\
})

// Returns an error and sets debug file and line number
#define RETURN_ERROR(e) ({\
    sans_error_set_file_line(__FILE__, __LINE__);\
    return e;\
})
