class_name WaveSystem
extends Node

static var instance: WaveSystem

signal wave_started
signal wave_ended

@export var enemy_spawn_locations: Array[Marker3D]
@export var enemy_container: Node3D
@export var wave_time_label: Label

var enemy_scene: PackedScene = preload("uid://dqdin3vaff0vi")

var current_wave: int = 0
var wave_time: float
var wave_duration: float = 30.0
var enemies_spawned: int
var total_enemies: int = 2
var spawn_time: float
var spawn_rate: float = 5.0
var started: bool

# Difficulty values
var min_wave_duration: float = 15.0
var max_wave_duration: float = 120.0

var min_total_enemies: int = 2

var start_spawn_rate: float = 5.0
var end_spawn_rate: float = 0.25

var start_enemy_health: int = 2
var end_enemy_health: int = 15

func _ready() -> void:
	instance = self

	start_next_wave()

func _process(delta: float) -> void:
	if !started:
		return

	wave_time -= delta
	wave_time = max(wave_time, 0.0)

	var minutes = int(wave_time) / 60.0
	var seconds = int(wave_time) % 60

	wave_time_label.text = "%02d:%02d" % [minutes, seconds]

	if get_enemy_count() == 0 and wave_time <= 0.0:
		started = false
		wave_ended.emit()
	elif enemies_spawned < total_enemies:
		spawn_time += delta

		if spawn_time >= spawn_rate:
			spawn_time = 0.0
			_spawn_enemy()


func _spawn_enemy():
	var spawn_location: Vector3 = enemy_spawn_locations.pick_random().global_position

	var enemy: NPC = enemy_scene.instantiate()

	enemy_container.add_child(enemy)

	enemy.global_position = spawn_location
	var enemy_health: Health = enemy.get_node("Health")
	enemy_health.max_health = int(get_wave_scaled_value(start_enemy_health, end_enemy_health))
	enemy_health.current_heatlh = enemy_health.max_health

	enemies_spawned += 1

func get_enemy_count() -> int:
	return enemy_container.get_child_count()

func start_next_wave():
	current_wave += 1

	wave_time = get_wave_scaled_value(min_wave_duration, max_wave_duration)
	enemies_spawned = 0

	spawn_rate = get_wave_scaled_value(start_spawn_rate, end_spawn_rate)
	spawn_time = spawn_rate

	total_enemies = min_total_enemies + current_wave * 2

	started = true

	wave_started.emit()

func is_wave_active() -> bool:
	return started

func get_wave_scaled_value(min_value: float, max_value: float) -> float:
	var progress = 1.0 - exp(-current_wave / 15.0)
	return lerp(min_value, max_value, progress)
