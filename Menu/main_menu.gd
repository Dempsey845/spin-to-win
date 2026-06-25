extends Node3D

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var transition_control: Transition = %TransitionControl

var world_scene: PackedScene = preload("uid://c2tcncjarsqqg")

func _ready() -> void:
    play_button.pressed.connect(_on_play_button_pressed)

    transition_control.transition_complete.connect(_on_transition_complete)

func _on_play_button_pressed():
    transition_control.start_transition()

func _on_transition_complete():
    get_tree().change_scene_to_packed(world_scene)