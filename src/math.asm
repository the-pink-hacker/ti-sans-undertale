number_to_string_99:
; Input:
;   a = number [0, 99]
; Output:
;   e = LSD
;   d = MSD
    ld b, a
    xor a, a

    .bit_0:
        bit 0, b
        jq z, .bit_0_end

        inc a
    .bit_0_end:

    .bit_1:
        bit 1, b
        jq z, .bit_1_end

        inc a
        inc a
    .bit_1_end:

    .bit_2:
        bit 2, b
        jq z, .bit_2_end

        add a, $04
    .bit_2_end:

    .bit_3:
        bit 3, b
        jq z, .bit_3_end

        add a, $08
        daa
    .bit_3_end:

    .bit_4:
        bit 4, b
        jq z, .bit_4_end

        add a, $16
        daa
    .bit_4_end:

    .bit_5:
        bit 5, b
        jq z, .bit_5_end

        add a, $32
        daa
    .bit_5_end:

    .bit_6:
        bit 6, b
        jq z, .bit_6_end

        add a, $64
        daa
    .bit_6_end:

    ld b, a
    and a, $0F
    add a, '0'
    ld d, a

    ld a, b
    rrca
    rrca
    rrca
    rrca
    and a, $0F
    add a, '0'
    ld e, a

    ret

; Domain: [1, 511]
u9_to_float_op1:
    xor a, a
    ld c, a

    .bit_0: ; 1
        bit 0, l
        jq z, .bit_0_end

        inc a
    .bit_0_end:

    .bit_1: ; 2
        bit 1, l
        jq z, .bit_1_end

        inc a
        inc a
    .bit_1_end:

    .bit_2: ; 4
        bit 2, l
        jq z, .bit_2_end

        add a, $04
    .bit_2_end:

    .bit_3: ; 8
        bit 3, l
        jq z, .bit_3_end

        add a, $08
        daa
    .bit_3_end:

    .bit_4: ; 16
        bit 4, l
        jq z, .bit_4_end

        add a, $16
        daa
    .bit_4_end:

    .bit_5: ; 32
        bit 5, l
        jq z, .bit_5_end

        add a, $32
        daa
    .bit_5_end:

    .bit_6: ; 64
        bit 6, l
        jq z, .bit_6_end

        add a, $64
        daa

        jq nc, .bit_6_end

        inc c
    .bit_6_end:

    .bit_7: ; 128
        bit 7, l
        jq z, .bit_7_end

        inc c
        add a, $28
        daa

        jq nc, .bit_7_end

        inc c
    .bit_7_end:

    .bit_8: ; 256
        bit 0, h
        jq z, .bit_8_end

        inc c
        inc c
        add a, $56
        daa

        jq nc, .bit_8_end
        inc c
    .bit_8_end:

    ld b, a
    ld a, c
    ; BCD = AA BB

    ld c, $81 ; Inital exponent

    .bcd_shift_loop:
        tst a, $F0
        jq nz, .bcd_shift_end

        inc c

        ; b << 4 copy to carry with zeros
        ; a << 4 with carry
        repeat 4
            sla b
            rla
        end repeat

        jp .bcd_shift_loop
    .bcd_shift_end:

    ld hl, ti.OP1 ; *op1
    ld (hl), 0 ; Real | Positive

    inc hl ; *op1.exponent
    ld (hl), c

    ld c, a
    inc hl ; *op1.mantissa[0]
    ld (hl), bc
    ; Exponent CC BB ?? ?? ?? ?? ??

    ld bc, 0
    inc hl
    inc hl ; *op1.mantissa[2]
    ld (hl), bc
    ; Exponent CC BB 00 00 00 ?? ??

    inc hl
    inc hl ; *op1.mantissa[4]
    ld (hl), bc
    ; Exponent CC BB 00 00 00 00 00

    ret

float_op1_to_u8:
; Domain: (-0.5, 255.5)
; Range: [0, 255]
; Arguments:
;   OP1 = float
; Return:
;   a = u8
;   OP1 = rounded value
    call ti.Int
    ld hl, ti.OP1 + 1
    ld b, (hl) ; Exponent
    ld a, $82
    sub a, (hl) ; $82 - exponent
    ld b, a
    or a, a

    jq z, .shift_skip

    inc hl
    ld hl, (hl) ; Mantissa

    .shift_loop:
        repeat 4
            srl l
            rra
        end repeat
        ld h, a

        djnz .shift_loop

    .shift_skip:

    .bcd_ones:
        ld a, h
        rrca
        rrca
        rrca
        rrca

    .bcd_tens:
        ld b, a
            ld a, l
            and a, $0F
            ld c, a
        ld a, b

        ld b, 10
        mlt bc
        add a, c

    .bcd_hundreds:
        srl l
        srl l
        srl l
        srl l

        ld h, 100
        mlt hl
        add a, l

    ret
