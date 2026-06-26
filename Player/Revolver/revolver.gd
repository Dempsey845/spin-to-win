class_name Revolver
extends RigidBody3D

@export var force_strength := 1000.0
@export var animation_player: AnimationPlayer

@onready var world_area: Area3D = $WorldArea
@onready var life_timer: Timer = $LifeTimer

var ammo: int = 6

func _ready() -> void:
	ammo = PlayerAmmo.instance.max_ammo
	world_area.body_entered.connect(_on_body_entered)

	life_timer.timeout.connect(func():
		queue_free()
	)

func init_force() -> void:
	var direction = -basis.z + Vector3.UP * 0.3
	direction = direction.normalized()

	apply_central_force(direction * force_strength)

func _on_body_entered(_other: Node):
	animation_player.play("default")
