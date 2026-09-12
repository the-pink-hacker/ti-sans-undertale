#include "init.h"

#include <ti/screen.h>
#include <graphx.h>

#include "ui.h"
#include "input.h"

sans_result_t sans_init(void) {
    EARLY_EXIT(sans_ui_init());
    os_RunIndicOff();
    os_ClrLCDFull();
    os_HomeUp();

    gfx_Begin();
    
    return SANS_SUCCESS;
}

void sans_exit(void) {
    sans_input_exit();
    gfx_End();
    os_ClrHomeFull();
    os_HomeUp();
    os_DrawStatusBar();
}
