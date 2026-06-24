extends Node3D

@export var textures: Array[Texture2D]

@onready var debris: GPUParticles3D = $Debris

func _ready() -> void:
	debris.emitting = true

	await get_tree().create_timer(5.0).timeout
	queue_free()
