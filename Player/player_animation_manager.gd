class_name PlayerAnimationManager
extends Node

signal shoot_animation_started
signal shoot_animation_ended

signal punch_animation_started
signal punch_animation_ended

signal equip_pistol_started
signal equip_pistol_ended

signal equip_punch_started
signal equip_punch_ended

signal grab_started
signal grab_ended

@onready var animation_tree: AnimationTree = $'../Head/AnimationTree'

func set_arm_state_machine_condition(condition_name: String, value: Variant):
	animation_tree.set("parameters/ArmStateMachine/conditions/%s" % condition_name, value)

func emit_shoot_animation_started():
	shoot_animation_started.emit()

func emit_shoot_animation_ended():
	shoot_animation_ended.emit()

func emit_punch_animation_started():
	punch_animation_started.emit()

func emit_punch_animation_ended():
	punch_animation_ended.emit()

func emit_equip_pistol_started():
	equip_pistol_started.emit()

func emit_equip_pistol_ended():
	equip_pistol_ended.emit()

func emit_equip_punch_started():
	equip_punch_started.emit()

func emit_equip_punch_ended():
	equip_punch_ended.emit()

func emit_grab_started():
	grab_started.emit()

func emit_grab_ended():
	grab_ended.emit()

func set_time_scale(time_scale: float):
	animation_tree.set("parameters/TimeScale/scale", time_scale)