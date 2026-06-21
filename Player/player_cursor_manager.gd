extends Node

@export var crosshair_cursor: TextureRect
@export var grab_cursor: TextureRect
@export var revolver_manager: PlayerRevolverManager

func _process(_delta: float) -> void:
	if revolver_manager.is_revolver_in_pickup():
		crosshair_cursor.visible = false
		grab_cursor.visible = true
	else:
		crosshair_cursor.visible = true
		grab_cursor.visible = false
