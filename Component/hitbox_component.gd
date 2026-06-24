class_name Hitbox
extends Area3D

signal hit_hurtbox(hurtbox: Hurtbox)

var blood_effect_scene = preload("uid://b56inmh1iqeq0")

@export var damage: int
@export var knockback: bool = true

var _active: bool
@export var active: bool = true:
	get():
		return _active
	set(value):
		_active = value
		if value:
			for area in get_overlapping_areas():
				_on_area_entered(area)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D):
	if area is not Hurtbox or not active:
		return
	
	# if knockback and area.get_parent() is NPC:
	# 	var npc: NPC = area.get_parent()
	# 	npc.apply_knockback(global_position, 5.0)

	if area.get_parent() is NPC and damage > 0:
		var blood_effect = blood_effect_scene.instantiate()
		get_tree().current_scene.add_child(blood_effect)
		blood_effect.global_position = global_position

	area.register_hit(damage)
	hit_hurtbox.emit(area)