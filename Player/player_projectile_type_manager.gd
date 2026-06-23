class_name ProjectileTypeManager
extends Node

enum ProjectileType {
	Regular,
	TripleShot,
	Explosive,
	SpeedStim,
	Healing,
	Empty
}

@export var colt_python: ColtPython
@export var ammo: PlayerAmmo

var regular_projectile_scene: PackedScene = preload("uid://smag44qmesee")

var _current_projectile_type: ProjectileType
var current_projectile_type: ProjectileType:
	get():
		return _current_projectile_type
	set(value):
		# Previous
		if _current_projectile_type == ProjectileType.Empty:
			colt_python.cyilnder_full.visible = true
			colt_python.cyilnder_empty.visible = false

		_current_projectile_type = value

		if _current_projectile_type == ProjectileType.Empty:
			colt_python.cyilnder_full.visible = false
			colt_python.cyilnder_empty.visible = true
			ammo.current_ammo = 0

func get_current_projectile_scene() -> PackedScene:
	return regular_projectile_scene

func _ready() -> void:
	current_projectile_type = ProjectileType.Explosive