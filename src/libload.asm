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
    libload_header "LibLoad", 31

; -----------------------------------------------------
; put the libraries here
; see below code snippet for information
; -----------------------------------------------------

gfx:
    libload_header "GRAPHX", 1
    
    libload_func .Begin, 0
    libload_func .End, 1
    libload_func .SetColor, 2
    libload_func .SetDraw, 9
    libload_func .SwapDraw, 10
    libload_func .Rectangle_NoClip, 41
    libload_func .Sprite_NoClip, 59
    libload_func .ZeroScreen, 76

kb:
    libload_header "KEYPADC", 1

    libload_func .ScanGroup, 1

io:
    libload_header "FILEIOC", 2

    libload_func .Open, 1
    libload_func .Close, 3
    libload_func .GetDataPtr, 18

    xor a, a      ; return z (loaded)
    pop hl      ; pop error return
    ret

libload_name:
    db ti.AppVarObj, "LibLoad", 0
    
    .len := $ - .
