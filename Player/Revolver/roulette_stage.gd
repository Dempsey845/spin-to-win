class_name RouletteStage
extends Control

signal type_chosen(type: ProjectileTypeManager.ProjectileType)

@export var main_camera: Camera3D

@onready var roulette_container: Node3D = %RouletteContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var roulette_scene: PackedScene = preload("uid://cj656lcmwed8g")
var bullet_result_scene: PackedScene = preload("uid://byo31pss3aoxc")

func _ready() -> void:
    start_transition()

func start_transition():
    get_tree().paused = true
    animation_player.play("fade_in")

func start_roulette():
    var roulette: Roulette = roulette_scene.instantiate()
    roulette.complete.connect(func():
        var bullet_result: BulletResult = bullet_result_scene.instantiate()
        bullet_result.type_chosen.connect(func(type: ProjectileTypeManager.ProjectileType):
            type_chosen.emit(type)
        )
        bullet_result.complete.connect(func():
            animation_player.play("fade_out")
        )
        add_child(bullet_result)
        roulette.queue_free()
    )
    roulette_container.add_child(roulette)

func end():
    get_tree().paused = false
    queue_free()