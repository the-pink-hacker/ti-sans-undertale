include "include/ez80.inc"
include "include/ti84pceg.inc"
include "include/tiformat.inc"
include "include/macros.inc"
format ti executable "SANS"

sans_undertale:
    .main:
        call ti.RunIndicOff
        call ti.ClrLCDAll
        call ti.HomeUp

        call load_libload_libraries
        jq nz, failed_to_load_libs

        call gaster_blaster.init

        call gfx.Begin

        call game.start
    .exit:
        call gfx.End
        call gaster_blaster.exit
    .exit_safe:
        call ti.ClrScrnFull
        call ti.HomeUp
        jp ti.DrawStatusBar

include "src/libload.asm"
include "src/game.asm"
include "src/player.asm"
include "src/collisions.asm"
include "src/attacks.asm"
include "src/sprites.asm"
