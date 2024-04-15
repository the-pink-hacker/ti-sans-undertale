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

float_op1_to_u8:
; Domain: (-0.5, 255.5)
; Range: [0, 255]
; Arguments:
;   OP1 = float
; Return:
;   a = u8
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
