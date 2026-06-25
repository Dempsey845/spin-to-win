extends Node

@export var settings: SettingsMenu

var is_ready: bool

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	is_ready = true

func _process(_delta: float) -> void:
	if is_ready and Input.is_action_just_pressed("settings"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		settings.visible = !settings.visible
	elif Input.is_action_just_pressed("shoot"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED