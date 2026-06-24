class_name MainCamera
extends Camera3D

static var instance: MainCamera

func _enter_tree() -> void:
    instance = self
