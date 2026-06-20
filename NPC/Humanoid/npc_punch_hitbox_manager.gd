extends Node

@export var punch_hitbox: Hitbox

func enable_hitbox():
    punch_hitbox.active = true

func disable_hitbox():
    punch_hitbox.active = false