class_name Health
extends Node

signal max_health_changed(new_max_health: int)
signal health_changed(new_health: int, change_amount: int)
signal damage_taken(damage_amount: int)
signal healed(heal_amount: int)
signal death

var _max_health: int = 5
@export var max_health: int:
	get():
		return _max_health
	set(value):
		_max_health = value
		max_health_changed.emit(value)

var _current_health: int
var current_heatlh: int:
	get:
		return _current_health
	set(value):
		var change_amount = _current_health - value
		_current_health = value
		health_changed.emit(value, change_amount)
		
		if value <= 0:
			death.emit()

func _ready() -> void:
	current_heatlh = max_health

func take_damage(damage_amount: int):
	current_heatlh -= damage_amount
	damage_taken.emit(damage_amount)

func heal(heal_amount: int):
	current_heatlh += heal_amount
	if current_heatlh > max_health:
		current_heatlh = max_health
	healed.emit(heal_amount)
