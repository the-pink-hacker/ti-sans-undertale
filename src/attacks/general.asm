attack.general.update:
    .set_player_soul_blue:
        ld (ix + flags.player_control.offset), flags.player_control.blue
        ret

    .set_player_soul_red:
        ld (ix + flags.player_control.offset), flags.player_control.red
        ret

    .throw_player_soul_down:
        bit flags.collision.hard_down_bit, (ix + flags.collision.offset)
        ret nz

        inc (ix + flags.player_soul_y.offset)
        ret

    .exit:
        res flags.attack.attack_loaded_bit, (ix + flags.attack.offset)
        ret
