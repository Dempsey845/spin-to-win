extends StaticBody3D

@onready var health: Health = $Health

func _ready() -> void:
    health.death.connect(_on_health_death)

func _on_health_death():
    queue_free()