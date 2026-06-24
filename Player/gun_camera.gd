extends Camera3D

@export var main_camera: Camera3D

func _ready() -> void:
	if not main_camera:
		if MainCamera.instance:
			main_camera = MainCamera.instance
		else:
			push_warning("No main camera found for gun camera. Position and rotation will not be synced.")

func _process(_delta: float) -> void:
	if not main_camera:
		return
		
	global_position = main_camera.global_position
	global_rotation = main_camera.global_rotation
