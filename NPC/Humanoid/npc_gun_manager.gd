extends Node

@export var revolver_visual: Node3D
@export var hand_attachment_slot: Node3D

@export var projectile_scene: PackedScene
@export var fire_point: Marker3D

func equip_revolver():
    revolver_visual.reparent(hand_attachment_slot)
    revolver_visual.position = Vector3.ZERO
    revolver_visual.rotation = Vector3.ZERO

func shoot_projectile():
    var projectile = projectile_scene.instantiate()
    get_tree().current_scene.add_child(projectile)

    projectile.global_position = fire_point.global_position
    projectile.global_rotation = fire_point.global_rotation