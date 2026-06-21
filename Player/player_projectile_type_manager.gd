class_name ProjectileTypeManager
extends Node

enum ProjectileType {
    Regular,
    TripleShot,
    Explosive,
    Ricochet,
    Healing,
    Empty
}

var regular_projectile_scene: PackedScene = preload("uid://smag44qmesee")
var current_projectile_type: ProjectileType = ProjectileType.TripleShot

func get_current_projectile_scene() -> PackedScene:
    match current_projectile_type:
        ProjectileType.Regular:
            return regular_projectile_scene
        ProjectileType.TripleShot:
            return regular_projectile_scene
    
    return regular_projectile_scene