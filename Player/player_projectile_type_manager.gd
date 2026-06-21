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

var regular_projectile_scene: PackedScene = preload("uid://smag44qmesee")
var current_projectile_type: ProjectileType = ProjectileType.SpeedStim

func get_current_projectile_scene() -> PackedScene:
    return regular_projectile_scene