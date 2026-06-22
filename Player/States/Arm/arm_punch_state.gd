class_name PlayerPunchState
extends State

@export var animation_manager: PlayerAnimationManager
@export var gun_state: State
@export var revolver_manager: PlayerRevolverManager

@onready var start_delay_timer: Timer = $StartDelayTimer

var can_punch: bool = true
var punch_with_left_hand: bool
var can_equip_pistol: bool = true

var punch_animation_duration: float = 1.25
var target_punch_rate: float = 1.25

func upgrade_punch_rate(percent_decrease: float = 0.90):
	target_punch_rate = target_punch_rate * percent_decrease
	target_punch_rate = max(target_punch_rate, 0.4)

func get_punch_rate_time_scale_multiplier():
	return punch_animation_duration / target_punch_rate

func enter():
	can_equip_pistol = true

	start_delay_timer.start()

	animation_manager.set_arm_state_machine_condition("punch_idle", true)
	animation_manager.set_arm_state_machine_condition("grab_success", false)
	animation_manager.set_arm_state_machine_condition("grab_failed", false)

	animation_manager.punch_animation_started.connect(_on_punch_animation_started)
	animation_manager.punch_animation_ended.connect(_on_punch_animation_ended)

	animation_manager.equip_pistol_started.connect(func():
		gun_state.gun_visual.visible = true
	)
	
	animation_manager.equip_pistol_ended.connect(func():
		animation_manager.set_arm_state_machine_condition("equip_pistol", false)
		state_machine.change_state(gun_state)
	)

	animation_manager.grab_started.connect(func():
		if revolver_manager.try_pickup_revolver():
			gun_state.gun_visual.visible = true
			animation_manager.set_arm_state_machine_condition("grab_success", true)
		else:
			animation_manager.set_arm_state_machine_condition("grab_failed", true)
		animation_manager.set_arm_state_machine_condition("grab", false)
	)

	animation_manager.grab_ended.connect(func():
		if revolver_manager.has_revolver:
			_equip_pistol(false)
	)

func update(_delta: float):
	if !start_delay_timer.is_stopped():
		return

	if Input.is_action_just_pressed("punch") and can_punch:
		_punch()
	elif Input.is_action_just_pressed("equip") and revolver_manager.has_revolver and can_equip_pistol:
		_equip_pistol()
	elif Input.is_action_just_pressed("pickup") and !revolver_manager.has_revolver:
		animation_manager.set_arm_state_machine_condition("grab", true)

func _punch():
	animation_manager.set_time_scale(get_punch_rate_time_scale_multiplier())
	if punch_with_left_hand:
			animation_manager.set_arm_state_machine_condition("punch_l", true)
	else:
		animation_manager.set_arm_state_machine_condition("punch_r", true)

	can_punch = false

func _equip_pistol(play_equip_animation: bool = true):
	can_equip_pistol = false
	animation_manager.set_arm_state_machine_condition("punch_idle", false)
	if play_equip_animation:
		animation_manager.set_arm_state_machine_condition("equip_pistol", true)
	else:
		state_machine.change_state(gun_state)

func exit():
	start_delay_timer.stop()

	animation_manager.set_arm_state_machine_condition("punch_idle", false)

	animation_manager.punch_animation_started.disconnect(_on_punch_animation_started)
	animation_manager.punch_animation_ended.disconnect(_on_punch_animation_ended)

func _on_punch_animation_started():
	if punch_with_left_hand:
		animation_manager.set_arm_state_machine_condition("punch_l", false)
	else:
		animation_manager.set_arm_state_machine_condition("punch_r", false)

	punch_with_left_hand = !punch_with_left_hand		

func _on_punch_animation_ended():
	can_punch = true
	animation_manager.set_time_scale(0.0)
