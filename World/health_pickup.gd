extends Area3D

@onready var container: Node3D = $Container
@onready var collision: CollisionShape3D = $CollisionShape3D

@export var spin_speed: float = 5.0
@export var float_amount: float = 0.2
@export var float_speed: float = 2.0

@onready var model_1: Node3D = $Container/Model1
@onready var model_2: MeshInstance3D = $Container/Model2

var time: float = 0.0
var start_y: float

var claimed: bool = false

func _ready():
	var models = [model_1, model_2]
	models.pick_random().queue_free()

	start_y = container.position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if claimed:
		return

	time += delta
	container.rotate_y(spin_speed * delta)
	container.position.y = start_y + sin(time * float_speed) * float_amount

func _on_body_entered(body: Node) -> void:
	if claimed:
		return

	if body is Player:
		claimed = true

		set_deferred("monitoring", false)
		collision.set_deferred("disabled", true)

		var health: Health = body.get_node("Health")
		health.heal(2)

		animate_out_and_delete()

func animate_out_and_delete() -> void:
	var tween := create_tween()

	tween.tween_property(container, "scale", Vector3.ZERO, 1.0)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(container, "position:y", container.position.y + 0.5, 1.0)

	tween.tween_callback(queue_free)