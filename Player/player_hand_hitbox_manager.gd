class_name PlayerHandHitboxManager
extends Node

@export var left_hand_hitbox: Hitbox
@export var right_hand_hitbox: Hitbox

@export var camera_shake: CameraShake

var blood_effect_scene = preload("uid://b56inmh1iqeq0")

var _damage: int = 1
var damage: int:
    get():
        return _damage
    set(value):
        _damage = value
        left_hand_hitbox.damage = value
        right_hand_hitbox.damage = value

func _ready() -> void:
    left_hand_hitbox.hit_hurtbox.connect(_on_hit_hurtbox.bind(left_hand_hitbox))
    right_hand_hitbox.hit_hurtbox.connect(_on_hit_hurtbox.bind(right_hand_hitbox))

func enable_left_handle_hitbox():
    left_hand_hitbox.active = true

func disable_left_hand_hitbox():
    left_hand_hitbox.active = false

func enable_right_hand_hitbox():
    right_hand_hitbox.active = true

func disable_right_hand_hitbox():
    right_hand_hitbox.active = false

func _on_hit_hurtbox(_hurtbox: Hurtbox, _hitbox: Hitbox):
    camera_shake.add_shake(0.15)
    # var blood_effect = blood_effect_scene.instantiate()
    # get_tree().current_scene.add_child(blood_effect)
    # blood_effect.global_position = hitbox.global_position
