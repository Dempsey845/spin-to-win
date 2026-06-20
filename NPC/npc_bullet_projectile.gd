extends Hitbox

@export var projectile_speed: float = 10.0

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	global_position += -global_basis.z * projectile_speed * delta

func _on_area_entered(area: Area3D):
	super._on_area_entered(area)
	queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()
