class_name PlayerHandHitboxManager
extends Node

@export var left_hand_hitbox: Hitbox
@export var right_hand_hitbox: Hitbox

var _damage: int = 1
var damage: int:
    get():
        return _damage
    set(value):
        _damage = value
        left_hand_hitbox.damage = value
        right_hand_hitbox.damage = value

func enable_left_handle_hitbox():
    left_hand_hitbox.active = true

func disable_left_hand_hitbox():
    left_hand_hitbox.active = false

func enable_right_hand_hitbox():
    right_hand_hitbox.active = true

func disable_right_hand_hitbox():
    right_hand_hitbox.active = false