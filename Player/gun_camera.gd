extends Camera3D

@export var main_camera: Camera3D

func _process(_delta: float) -> void:
	global_position = main_camera.global_position
	global_rotation = main_camera.global_rotation
