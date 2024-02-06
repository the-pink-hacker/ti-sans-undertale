check_collision_inner_box:
; Arguments:
;       (03) box_x: u24
;       (06) box_y: u8
;       (09) box_size: $00XXYY
;       (12) player: *position
; Return:
;       Sets collision flags. Never resets.
    ld iy, 0
    add iy, sp

    .up:
        ld a, (iy + 6) ; box_y
        ld hl, (iy + 12) ; *player.y
        ld b, (hl) ; player.y

        ; box_y < player.y
        cp a, b
        jq c, .up_end

        ; Collision
        set flags.collision.up_bit, (ix + flags.collision.offset)
    .up_end:

    .down:
        add a, (iy + 9) ; box_size.y
        ld c, a

        ld a, b ; player.y
        add a, 8

        ; player.y + player_size < box_y + box_size.y
        cp a, c
        jq c, .down_end

        ; Collision
        set flags.collision.down_bit, (ix + flags.collision.offset)
    .down_end:

    .left:
        inc hl ; *player.x
        ld de, (hl) ; player.x
        ld hl, (iy + 3) ; box_x

        ; box_x < player.x
        ; Carry is unknown
        cp a, a ; Resets carry
        sbc hl, de
        jq c, .left_end

        ; Collision
        set flags.collision.left_bit, (ix + flags.collision.offset)
    .left_end:
    
    .right:
        ld hl, 0
        ld l, (iy + 10) ; box_size.x
        ld bc, (iy + 3) ; box_x
        add hl, bc ; box_size.x + box_x
        ex de, hl ; de = box_size.x + box_x

        ld hl, (iy + 12) ; *player.y
        inc hl ; *player.x
        ld hl, (hl)
        ld bc, 8 ; player_size
        add hl, bc ; player.x + player_size
                   ; Resets carry
                   ; unless the player's x is greater than 16_777_208.
                   ; Hopefully this isn't the case.

        ; player.x + player_size < box_x + box_size.x
        sbc hl, de
        jq c, .right_end

        set flags.collision.right_bit, (ix + flags.collision.offset)
    .right_end:

    ret

reset_collision_flags:
    xor a, a
    ld (ix + flags.collision.offset), a
    ret
