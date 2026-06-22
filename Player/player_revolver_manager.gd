class_name PlayerRevolverManager
extends Node

signal revolver_picked_up

@export var pickup_ray: RayCast3D
@export var revolver_status_animation_player: AnimationPlayer

var has_revolver: bool = true

func _ready() -> void:
    WaveSystem.instance.wave_ended.connect(func():
        if !has_revolver:
            revolver_status_animation_player.play("fade_in")
    )

func is_revolver_in_pickup() -> bool:
    if has_revolver:
        return false
    
    pickup_ray.force_raycast_update()

    return pickup_ray.is_colliding()

func try_pickup_revolver() -> bool:
    if !has_revolver:
        pickup_ray.force_raycast_update()

        if pickup_ray.is_colliding():
            var revolver: Revolver = pickup_ray.get_collider()

            revolver.queue_free()

            has_revolver = true

            if revolver_status_animation_player.current_animation == "idle":
                revolver_status_animation_player.play("fade_out")
            
            revolver_picked_up.emit()

            return true

    return false

func drop():
    has_revolver = false
    if !WaveSystem.instance.is_wave_active():
        revolver_status_animation_player.play("fade_in")