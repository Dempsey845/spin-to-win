class_name ButtonComponent
extends AudioStreamPlayer

func _ready() -> void:
	bus = "SFX"

	stream = load("uid://cahmjkit8pq5d")

	await get_tree().process_frame

	var button = get_parent()

	if button is Button:
		button.connect("pressed", _on_button_pressed)
	elif button is SettingsSection:
		button.connect("tab_button_pressed", _on_button_pressed)

func _on_button_pressed():
	play()
