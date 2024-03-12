include "include/ez80.inc"
include "include/ti84pceg.inc"
include "include/tiformat.inc"
include "include/macros.inc"
include "include/math.inc"
format ti executable "SANS"

assume adl=1

TRIG_ITERATIONS := 8

sans_undertale:
    .main:
        call ti.RunIndicOff
        call ti.ClrLCDAll
        call ti.HomeUp

        call load_libload_libraries
        jq nz, failed_to_load_libs

        call gaster_blaster.init
        call text.init

        call gfx.Begin

        call game.start
    .exit:
        call gfx.End
    .exit_safe:
        call ti.ClrScrnFull
        call ti.HomeUp
        jp ti.DrawStatusBar

include "src/libload.asm"
include "src/game.asm"
include "src/player.asm"
include "src/collisions.asm"
include "src/math.asm"
include "src/attacks.asm"
include "src/text.asm"
include "src/sprites.asm"

total_bytes := $ - ti.userMem

if total_bytes >= 64 * 1024
    err "File size is too big (>64KB)."
else
    bytes_left := 64 * 1024 - total_bytes
    display "remaining: "
    display_decimal bytes_left / 1024
    display " KB + "
    display_decimal bytes_left mod 1024 
    display " B = "
    display_decimal bytes_left
    display " B"
end if
