class_name PlayerRevolverManager
extends Node

@export var pickup_ray: RayCast3D

var has_revolver: bool = false

func try_pickup_revolver():
    if !has_revolver:
        pickup_ray.force_raycast_update()

        if pickup_ray.is_colliding():
            var revolver: Revolver = pickup_ray.get_collider()

            # TODO: Queue free the revolver when hand is close to it (via call method from animation)
            revolver.queue_free()

            _pickup_revolver()


func _pickup_revolver():
    # Play the animation
    has_revolver = true