class_name PlayerAnimationManager
extends Node

signal shoot_animation_started
signal shoot_animation_ended

@onready var animation_tree: AnimationTree = $'../Head/AnimationTree'

func set_arm_state_machine_condition(condition_name: String, value: Variant):
	animation_tree.set("parameters/ArmStateMachine/conditions/%s" % condition_name, value)

func emit_shoot_animation_started():
	shoot_animation_started.emit()

func emit_shoot_animation_ended():
	shoot_animation_ended.emit()
