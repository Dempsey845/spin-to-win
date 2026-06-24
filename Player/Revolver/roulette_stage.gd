class_name RouletteStage
extends Control

signal type_chosen(type: ProjectileTypeManager.ProjectileType)

const UPGRADE_FREQUENCY: int = 1

@export var main_camera: Camera3D

@onready var roulette_container: Node3D = %RouletteContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var upgrade_control: UpgradeControl = $UpgradeControl

var roulette_scene: PackedScene = preload("uid://cj656lcmwed8g")
var bullet_result_scene: PackedScene = preload("uid://byo31pss3aoxc")

var upgrade_manager: PlayerUpgradeManager

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
			if WaveSystem.instance.current_wave % UPGRADE_FREQUENCY == 0:
				animation_player.play("text_out")
			else:
				animation_player.play("fade_out")

			WaveSystem.instance.start_next_wave()
		)

		add_child(bullet_result)
		roulette.queue_free()
	)
	roulette_container.add_child(roulette)

func end():
	get_tree().paused = false
	queue_free()

func start_upgrade():
	upgrade_control.start_upgrade()
	upgrade_control.upgrade_claimed.connect(_on_upgrade_claimed)

func _on_upgrade_claimed(upgrade_type: UpgradeOption.UpgradeType):
	if not upgrade_manager:
		push_warning("No upgrade manager found. This means the upgrade cannot be claimed!")
	else:
		upgrade_manager.claim_upgrade(upgrade_type)
	animation_player.play("fade_out_no_text")
