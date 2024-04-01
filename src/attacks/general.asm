attack.general.update:
    .set_player_soul_blue:
        ld (ix + flags.player_control.offset), flags.player_control.blue
        ret

    .set_player_soul_red:
        ld (ix + flags.player_control.offset), flags.player_control.red
        ret

    .throw_player_soul_down:
        ld (ix + flags.player_soul_y.offset), box_y + box_size - box_thickness - sprites.heart_red.height
        ret

    .exit:
        res flags.attack.attack_loaded_bit, (ix + flags.attack.offset)
        ret
