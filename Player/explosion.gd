extends Area3D

@export var damage: int = 2

func _ready() -> void:
    await get_tree().create_timer(0.1).timeout
    explode.call_deferred()

func explode():
    var overlapping_areas := get_overlapping_areas()

    for area: Area3D in overlapping_areas:
        if area is Hurtbox:
            area.register_hit(damage)

    await get_tree().create_timer(3.0).timeout
    queue_free()