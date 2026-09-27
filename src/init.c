#include "init.h"

#include <ti/screen.h>
#include <graphx.h>

#include "ui.h"
#include "input.h"
#include "entity.h"
#include "bone/wave.h"

sans_result_t sans_init(void) {
    os_RunIndicOff();
    os_ClrLCDFull();
    os_HomeUp();

    gfx_Begin();
    gfx_ZeroScreen();

    EARLY_EXIT(sans_ui_init());
    sans_bone_wave_init();
    
    return SANS_SUCCESS;
}

void sans_exit(void) {
    sans_input_exit();
    sans_entity_exit();
    gfx_End();
    os_ClrHomeFull();
    os_HomeUp();
    os_DrawStatusBar();
}
