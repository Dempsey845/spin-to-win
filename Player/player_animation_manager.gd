class_name PlayerAnimationManager
extends Node

@onready var animation_tree: AnimationTree = $'../Head/AnimationTree'

func set_arm_state_machine_condition(condition_name: String, value: Variant):
	animation_tree.set("parameters/ArmStateMachine/conditions/%s" % condition_name, value)

