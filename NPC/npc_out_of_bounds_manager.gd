extends Node

@export var health: Health

@onready var npc: NPC = get_parent()

var min_y: float = -2.0
var max_y: float = 15.0
var max_x: float = 97.0
var min_x: float = -110.0
var max_z: float = 70.0
var min_z: float = -70.0
var was_out_of_bounds: bool

func _process(_delta: float) -> void:
	var pos = npc.global_position
	
	var is_out_of_bounds = (
		pos.x < min_x or pos.x > max_x
		or pos.y < min_y or pos.y > max_y
		or pos.z < min_z or pos.z > max_z
	)
	
	if is_out_of_bounds and not was_out_of_bounds:
		print("NPC is out of bounds: ", pos)
		health.take_damage(health.max_health * 2)
	
	was_out_of_bounds = is_out_of_bounds