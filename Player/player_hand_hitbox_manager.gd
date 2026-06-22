class_name PlayerHandHitboxManager
extends Node

@export var left_hand_hitbox: Hitbox
@export var right_hand_hitbox: Hitbox

@export var camera_shake: CameraShake

var _damage: int = 1
var damage: int:
    get():
        return _damage
    set(value):
        _damage = value
        left_hand_hitbox.damage = value
        right_hand_hitbox.damage = value

func _ready() -> void:
    left_hand_hitbox.hit_hurtbox.connect(_on_hit_hurtbox)
    right_hand_hitbox.hit_hurtbox.connect(_on_hit_hurtbox)

func enable_left_handle_hitbox():
    left_hand_hitbox.active = true

func disable_left_hand_hitbox():
    left_hand_hitbox.active = false

func enable_right_hand_hitbox():
    right_hand_hitbox.active = true

func disable_right_hand_hitbox():
    right_hand_hitbox.active = false

func _on_hit_hurtbox(_hurtbox: Hurtbox):
    camera_shake.add_shake(0.15)
