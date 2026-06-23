extends ColorRect

@export var health: Health

func _ready() -> void:
    health.damage_taken.connect(_on_damage_taken)

func _on_damage_taken(_damage_amount: int):
    material.set_shader_parameter("strength", 0.55)

    var tween = create_tween()
    tween.tween_property(
        material,
        "shader_parameter/strength",
        0.0,
        0.5
    )