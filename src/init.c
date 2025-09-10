#include <ti/screen.h>
#include <graphx.h>

void sans_init(void) {
    os_RunIndicOff();
    os_ClrLCDFull();
    os_HomeUp();

    gfx_Begin();
}

void sans_exit(void) {
    gfx_End();
    os_ClrHomeFull();
    os_HomeUp();
    os_DrawStatusBar();
}
