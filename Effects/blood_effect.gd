extends Node3D

@export var textures: Array[Texture2D]
@export var decals: Array[Decal]

@onready var debris: GPUParticles3D = $Debris

func _ready() -> void:
	debris.emitting = true
	await get_tree().create_timer(0.5).timeout
	for decal in decals:
		if !is_instance_valid(decal):
			continue
			
		decal.texture_albedo = textures.pick_random()
		decal.get_node("AnimationPlayer").play("start")
		decal.rotation.y = deg_to_rad(randf_range(-90.0, 90.0))
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout

	await get_tree().create_timer(5.0).timeout
	queue_free()
