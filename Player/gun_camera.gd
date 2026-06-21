extends Camera3D

@export var main_camera: Camera3D

func _ready() -> void:
	if not main_camera:
		main_camera = get_parent().get_parent().get_parent().main_camera

func _process(_delta: float) -> void:
	global_position = main_camera.global_position
	global_rotation = main_camera.global_rotation
