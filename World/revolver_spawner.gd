class_name RevolverSpawner
extends Marker3D

@export var spawn_delay: float = 10.0
@export var spawn_on_start: bool

var revolver_scene: PackedScene = preload("uid://mettisjl70wh")

var current_revolver: Revolver

var delay_time: float

func _ready() -> void:
    if spawn_on_start:
        try_spawn()

func _process(delta: float) -> void:
    if current_revolver and is_instance_valid(current_revolver):
        return

    delay_time += delta

    if delay_time > spawn_delay:
        delay_time = 0.0
        try_spawn()

func try_spawn():
    if current_revolver and is_instance_valid(current_revolver):
        return
    
    current_revolver = revolver_scene.instantiate()
    add_child(current_revolver)

    current_revolver.global_position = global_position
    current_revolver.global_rotation = global_rotation