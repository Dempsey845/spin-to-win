class_name ButtonComponent
extends AudioStreamPlayer

func _ready() -> void:
    stream = load("uid://cahmjkit8pq5d")

    var button: Button = get_parent()

    button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
    play()