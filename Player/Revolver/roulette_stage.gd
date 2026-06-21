class_name RouletteStage
extends Control

@export var main_camera: Camera3D

@onready var roulette_container: Node3D = %RouletteContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var roulette_scene: PackedScene = preload("uid://cj656lcmwed8g")

func _ready() -> void:
    start_transition()

func start_transition():
    get_tree().paused = true
    animation_player.play("fade_in")

func start_roulette():
    roulette_container.add_child(roulette_scene.instantiate())