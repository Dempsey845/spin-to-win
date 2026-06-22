class_name PlayerPunchState
extends State

@export var animation_manager: PlayerAnimationManager
@export var gun_state: State
@export var revolver_manager: PlayerRevolverManager

@onready var start_delay_timer: Timer = $StartDelayTimer

var punch_with_left_hand: bool

var punch_animation_duration: float = 1.25
var target_punch_rate: float = 1.25

var is_grabbing: bool

func upgrade_punch_rate(percent_decrease: float = 0.90):
	target_punch_rate = target_punch_rate * percent_decrease
	target_punch_rate = max(target_punch_rate, 0.4)

func get_punch_rate_time_scale_multiplier():
	return punch_animation_duration / target_punch_rate

func enter():
	start_delay_timer.start()

	animation_manager.travel_state("Punch_Idle")

	animation_manager.punch_animation_started.connect(_on_punch_animation_started)
	animation_manager.punch_animation_ended.connect(_on_punch_animation_ended)

	animation_manager.equip_pistol_started.connect(func():
		gun_state.gun_visual.visible = true
	)
	
	animation_manager.equip_pistol_ended.connect(func():
		state_machine.change_state(gun_state)
	)

	animation_manager.grab_started.connect(func():
		is_grabbing = true
		if revolver_manager.try_pickup_revolver():
			gun_state.gun_visual.visible = true
			animation_manager.travel_state("Pistol_Idle")
		else:
			animation_manager.travel_state("Punch_Idle")
	)

	animation_manager.grab_ended.connect(func():
		is_grabbing = false
		if revolver_manager.has_revolver:
			_equip_pistol(false)
	)

func update(_delta: float):
	if !start_delay_timer.is_stopped() or is_grabbing:
		return

	if Input.is_action_just_pressed("punch"):
		_punch()
	elif Input.is_action_just_pressed("equip") and revolver_manager.has_revolver:
		_equip_pistol()
	elif Input.is_action_just_pressed("pickup") and !revolver_manager.has_revolver:
		animation_manager.travel_state("Grab")

func _punch():
	animation_manager.set_time_scale(get_punch_rate_time_scale_multiplier())
	if punch_with_left_hand:
		animation_manager.travel_state("Punch_L")
	else:
		animation_manager.travel_state("Punch_R")


func _equip_pistol(play_equip_animation: bool = true):
	if play_equip_animation:
		animation_manager.travel_state("Equip_Pistol")
	else:
		state_machine.change_state(gun_state)

func exit():
	start_delay_timer.stop()

	animation_manager.punch_animation_started.disconnect(_on_punch_animation_started)
	animation_manager.punch_animation_ended.disconnect(_on_punch_animation_ended)

func _on_punch_animation_started():
	punch_with_left_hand = !punch_with_left_hand		

func _on_punch_animation_ended():
	animation_manager.set_time_scale(1.0)
