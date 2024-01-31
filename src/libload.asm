; returns z if loaded, nz if not loaded
load_libload_libraries:
    jr .tryfind

    .inram:
        call ti.Arc_Unarc

    .tryfind:
        ld hl, libload_name
        call ti.Mov9ToOP1
        call ti.ChkFindSym
        jr c, .notfound
        call ti.ChkInRam
        jr z, .inram
        ld hl, 9 + 3 + libload_name.len
        add hl, de
        ld a, (hl)
        cp a, $1F
        jr c, .notfound
        dec hl
        dec hl
        ld de, relocations
        ld bc, .notfound
        push bc
        ld bc, $AA55AA
        jp (hl)

    .notfound:
        xor a, a
        inc a
        ret

failed_to_load_libs:
    ld hl, .text
    call ti.PutS
    call ti.GetKey
    jp sans_undertale.exit_safe

    .text:
        db "Failed to load libs.", 0


relocations:
libload_libload:
    db $C0, "LibLoad", 0, $1F


; -----------------------------------------------------
; put the libraries here
; see below code snippet for information
; -----------------------------------------------------

gfx:
    db $C0, "GRAPHX", 0, 1
    
    .Begin:
        jp 3 * 0
    .End:
        jp 3 * 1
    .SetDraw:
        jp 3 * 9
    .SwapDraw:
        jp 3 * 10
    
        xor a, a      ; return z (loaded)
        pop hl      ; pop error return
        ret

libload_name:
    db ti.AppVarObj, "LibLoad", 0
    
    .len := $ - .
