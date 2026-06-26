class_name NPCHumanoid
extends Node3D

signal hit_animation_complete
signal shoot_animation_complete
signal punch_animation_complete

@export var npc: NPC
@export var health: Health
@export var air_tracker: NPCAirState  
@export var muzzle_flash: VFXController

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var skeleton_3d: Skeleton3D = $Skeleton3D
@onready var fire_point: Marker3D = $FirePoint

var upper_body_state_machine: AnimationNodeStateMachinePlayback
var playing_upper_body_animation: bool

var skins = [
	preload("uid://mcmnrwo4ha5f"),
	preload("uid://dxrmfn0ql4rdx"),
	preload("uid://bm733e47xk7rd"),
	preload("uid://b0164a26ko5ft")
]
func _ready() -> void:
	skeleton_3d.add_child(skins.pick_random().instantiate())

	animation_tree.active = true

	air_tracker.falling_started.connect(_on_falling_started)
	air_tracker.falling_ended.connect(_on_landed)
	
	npc.jump_started.connect(jump)

	upper_body_state_machine = animation_tree.get(
		"parameters/UpperBodyStateMachine/playback"
	)


func _process(_delta: float) -> void:
	if npc == null or health.current_heatlh <= 0:
		return

	var velocity: Vector3 = npc.velocity
	var character_basis: Basis = npc.global_transform.basis

	var local_velocity := character_basis.inverse() * velocity

	var blend_vector := Vector2(
		local_velocity.x,
		-local_velocity.z
	).limit_length(1.0)

	animation_tree.set(
		"parameters/LocomotionStateMachine/Locomotion/blend_position",
		blend_vector
	)

	set_time_scale(npc.speed_multiplier)

func play_death_animation():
	var tween := create_tween()

	tween.tween_property(
		animation_tree,
		"parameters/DeathBlend/blend_amount",
		1.0,
		0.25
	)

func play_one_shot(one_shot_name: String):
	animation_tree.set(
		"parameters/%s/request" % one_shot_name,
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)

func abort_one_shot(one_shot_name: String):
	animation_tree.set(
		"parameters/%s/request" % one_shot_name,
		AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	)

func play_upper_body_animation(state_name: String):
	upper_body_state_machine.travel(state_name)

func play_upper_body_animation_one_shot(state_name: String, animation_length: float, blend_time: float = 0.1):
	if playing_upper_body_animation:
		push_warning("Already playing an upper body animation!")
		return
	
	start_upper_body_blend(_player_up_body_anim_one_shot.bind(state_name, animation_length, blend_time), blend_time)

func _player_up_body_anim_one_shot(state_name: String, animation_length: float, blend_time: float):
	upper_body_state_machine.travel(state_name)
	playing_upper_body_animation = true
	
	await get_tree().create_timer(animation_length).timeout
	stop_upper_body_blend(func(): playing_upper_body_animation = false, blend_time)

func start_upper_body_blend(on_complete: Callable = Callable(), blend_time: float = 0.1) -> void:
	set_upper_body_blend_amount(1.0, blend_time, on_complete)

func stop_upper_body_blend(on_complete: Callable = Callable(), blend_time: float = 0.1) -> void:
	set_upper_body_blend_amount(0.0, blend_time, on_complete)
	
func set_upper_body_blend_amount(target_amount: float, blend_time: float = 0.25, on_complete: Callable = Callable()):
	var tween := create_tween()

	tween.tween_property(
		animation_tree,
		"parameters/UpperBodyBlend/blend_amount",
		target_amount,
		blend_time
	)

	tween.finished.connect(func():
		if on_complete.is_valid():
			on_complete.call()
	)


func _on_falling_started() -> void:
	animation_tree.set(
		"parameters/LocomotionStateMachine/conditions/falling",
		true
	)

func _on_landed() -> void:
	animation_tree.set(
		"parameters/LocomotionStateMachine/conditions/falling",
		false
	)

	animation_tree.set(
		"parameters/LocomotionStateMachine/conditions/land",
		true
	)

	await get_tree().process_frame
	animation_tree.set(
		"parameters/LocomotionStateMachine/conditions/land",
		false
	)

func jump() -> void:
	animation_tree.set(
		"parameters/LocomotionStateMachine/conditions/jump",
		true
	)
	
	await get_tree().process_frame
	
	animation_tree.set(
		"parameters/LocomotionStateMachine/conditions/jump",
		false
	)

func emit_hit_animation_complete():
	hit_animation_complete.emit()

func emit_shoot_animation_complete():
	shoot_animation_complete.emit()

func emit_punch_complete():
	punch_animation_complete.emit()

func set_time_scale(time_scale: float):
	animation_tree.set("parameters/TimeScale/scale", time_scale)

func play_muzzle_flash():
	muzzle_flash.visible = true
	muzzle_flash.play()