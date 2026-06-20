extends RigidBody3D

@export var force_strength := 1000.0
@export var animation_player: AnimationPlayer

@onready var world_area: Area3D = $WorldArea

func _ready() -> void:
	print("Ready")
	world_area.body_entered.connect(_on_body_entered)

func init_force() -> void:
	var direction = -basis.z + Vector3.UP * 0.3
	direction = direction.normalized()

	apply_central_force(direction * force_strength)

func _on_body_entered(other: Node):
	print("Body entered %s" % other.name)
	animation_player.play("default")