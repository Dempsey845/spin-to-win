extends Decal

@onready var ray_cast_3d: RayCast3D = $RayCast3D

func _ready() -> void:
    await get_tree().process_frame
    ray_cast_3d.force_raycast_update()

    if ray_cast_3d.is_colliding():
        print(ray_cast_3d.get_collider().name)
        global_position = ray_cast_3d.get_collision_point()
        print(ray_cast_3d.get_collision_point())
    else:
        queue_free()