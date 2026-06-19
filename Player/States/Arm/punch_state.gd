extends State

@export var animation_manager: PlayerAnimationManager

var can_punch: bool = true
var punch_with_left_hand: bool

func enter():
	animation_manager.set_arm_state_machine_condition("punch_idle", true)

	animation_manager.punch_animation_started.connect(_on_punch_animation_started)
	animation_manager.punch_animation_ended.connect(_on_punch_animation_ended)

func update(_delta: float):
	if Input.is_action_just_pressed("punch") and can_punch:
		if punch_with_left_hand:
			animation_manager.set_arm_state_machine_condition("punch_l", true)
		else:
			animation_manager.set_arm_state_machine_condition("punch_r", true)

		can_punch = false

func exit():
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
