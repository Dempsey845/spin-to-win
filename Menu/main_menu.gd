extends Node3D

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var transition_control: Transition = %TransitionControl
@onready var settings: SettingsMenu = %Settings

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	play_button.pressed.connect(_on_play_button_pressed)
	settings_button.pressed.connect(func():
		settings.visible = true
	)

	transition_control.transition_complete.connect(_on_transition_complete)

	quit_button.pressed.connect(func():
		get_tree().quit()
	)

func _on_play_button_pressed():
	transition_control.start_transition()

func _on_transition_complete():
	var load_result: int = get_tree().change_scene_to_file("uid://c2tcncjarsqqg")

	while load_result != OK:
		push_warning("Failed to change scene. Trying again in 1 second.")
		await get_tree().create_timer(1.0).timeout
		load_result = get_tree().change_scene_to_file("uid://c2tcncjarsqqg")
