class_name Projectile
extends Hitbox

@export var projectile_speed: float = 10.0

var on_hit_callable: Callable

func _ready() -> void:
	super._ready()
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	global_position += -global_basis.z * projectile_speed * delta

func _on_area_entered(area: Area3D):
	super._on_area_entered(area)

	if on_hit_callable:
		on_hit_callable.call(area, global_position)

	queue_free()

func _on_body_entered(body: Node):
	if on_hit_callable:
		on_hit_callable.call(body, global_position)

	queue_free()

func _on_life_timer_timeout() -> void:
	queue_free()
