extends State

@export var npc: NPC
@export var humanoid: NPCHumanoid
@export var health: Health
@export var hit_state: State

@export var wander_radius: float = 10.0
@onready var wait_timer: Timer = $WaitTimer

var playing_hit_animation: bool
var destination: Vector3

func _ready() -> void:
	wait_timer.timeout.connect(_on_wait_timer_timeout)
	
	connect_navigation_finished.call_deferred()

func connect_navigation_finished():
	actor.navigation_finished.connect(_on_navigation_finished)

func enter():
	if actor is not NPC:
		push_error("This State is only compatible with NPC's!")

	health.damage_taken.connect(_on_health_damage_taken)
	humanoid.hit_animation_complete.connect(_on_hit_animation_complete)

	wait_timer.start()

func exit():
	wait_timer.stop()

	health.damage_taken.disconnect(_on_health_damage_taken)
	humanoid.hit_animation_complete.disconnect(_on_hit_animation_complete)

func pick_new_destination() -> void:
	var random_offset = Vector3(
		randf_range(-wander_radius, wander_radius),
		0,
		randf_range(-wander_radius, wander_radius)
	)

	var target = actor.global_position + random_offset
	destination = NavigationServer3D.map_get_closest_point(
		actor.get_world_3d().navigation_map,
		target
	)

	actor.set_target_position(destination)
	actor.move = true

func _on_navigation_finished():
	wait_timer.start()

func _on_wait_timer_timeout():
	pick_new_destination()

func _on_health_damage_taken(_damage_amount: int):
	if playing_hit_animation:
		return

	npc.move = false
	playing_hit_animation = true
	humanoid.play_one_shot("HitForward")

func _on_hit_animation_complete():
	playing_hit_animation = false
	npc.move = true
	state_machine.change_state(hit_state)
