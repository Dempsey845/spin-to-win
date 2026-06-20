class_name PlayerRevolverManager
extends Node

@export var pickup_ray: RayCast3D

var has_revolver: bool = true

func try_pickup_revolver() -> bool:
    if !has_revolver:
        pickup_ray.force_raycast_update()

        if pickup_ray.is_colliding():
            var revolver: Revolver = pickup_ray.get_collider()

            revolver.queue_free()

            has_revolver = true

            return true

    return false

