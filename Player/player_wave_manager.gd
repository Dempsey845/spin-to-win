extends Node

@export var canvas_layer: CanvasLayer
@export var revolver_manager: PlayerRevolverManager
@export var main_camera: Camera3D
@export var ammo: PlayerAmmo
@export var projectile_type_manager: ProjectileTypeManager

var roulette_stage_scene: PackedScene = preload("uid://bokhiklspil1b")

func _ready() -> void:
	WaveSystem.instance.wave_started.connect(_on_wave_started)
	WaveSystem.instance.wave_ended.connect(_on_wave_ended)
 
func _on_wave_started():
	if revolver_manager.revolver_picked_up.is_connected(_on_revolver_picked_up):
		revolver_manager.revolver_picked_up.disconnect(_on_revolver_picked_up)

func _on_wave_ended():
	if revolver_manager.has_revolver:
		start_roulette()
		return

	if !revolver_manager.revolver_picked_up.is_connected(_on_revolver_picked_up):
		revolver_manager.revolver_picked_up.connect(_on_revolver_picked_up)

func _on_revolver_picked_up():
	start_roulette()

func start_roulette():
	if canvas_layer.has_node("RouletteStage"):
		return

	var roulette_stage: RouletteStage = roulette_stage_scene.instantiate()
	roulette_stage.main_camera = main_camera
	canvas_layer.add_child(roulette_stage)

	roulette_stage.type_chosen.connect(func(type: ProjectileTypeManager.ProjectileType):
		ammo.current_ammo = ammo.max_ammo
		projectile_type_manager.current_projectile_type = type
	)
	