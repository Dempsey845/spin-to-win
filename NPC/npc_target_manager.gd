class_name NPCTargetManager
extends Node

@export var npc: NPC

@onready var chase_update_timer = $ChaseUpdateTimer

var target: Node3D

func _ready() -> void:
	chase_update_timer.timeout.connect(_on_chase_update_timer_timeout)

func _process(_delta: float) -> void:
	if target:
		npc.look_at_point(target.global_position)

func _on_chase_update_timer_timeout():
	if target:
		npc.set_target_position(target.global_position)

func set_target(new_target: Node3D):
	target = new_target
	_on_chase_update_timer_timeout()
	chase_update_timer.start()

func clear_target():
	target = null
	npc.clear_look_target()

func get_distance_sq_to_target():
	return npc.global_position.distance_squared_to(target.global_position)