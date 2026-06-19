extends Node

@export var left_hand_hitbox: Hitbox
@export var right_hand_hitbox: Hitbox

func enable_left_handle_hitbox():
    left_hand_hitbox.active = true

func disable_left_hand_hitbox():
    left_hand_hitbox.active = false

func enable_right_hand_hitbox():
    right_hand_hitbox.active = true

func disable_right_hand_hitbox():
    right_hand_hitbox.active = false