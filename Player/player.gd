class_name Player
extends CharacterBody3D

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002
@export var ammo: PlayerAmmo

var gravity: float = 9.8

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Pivot/MainCamera
@onready var arms: Node3D = $Head/Arms_001
@onready var step_stream_player: AudioStreamPlayer = $StepStreamPlayer
@onready var jump_stream_player: AudioStreamPlayer = $JumpStreamPlayer

# Camera sway/bob
@export var bob_frequency := 5.0
@export var bob_amplitude := 0.02

@export var sway_amount := 0.01
@export var sway_speed := 8.0

var bob_time := 0.0

var camera_start_pos: Vector3
var arms_start_pos: Vector3
var arms_start_rot: Vector3

var sway_target := Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	WaveSystem.instance.wave_started.connect(func():
		ammo.current_ammo = ammo.max_ammo
	)

	camera_start_pos = camera.position
	arms_start_pos = arms.position
	arms_start_rot = arms.rotation


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		head.rotate_x(-event.relative.y * mouse_sensitivity)

		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-89),
			deg_to_rad(89)
		)

		sway_target = event.relative

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	_update_weapon_sway(delta)

func _physics_process(delta: float):
	_try_apply_gravity(delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		jump_stream_player.play()

	_handle_movement()

	move_and_slide()

	_update_headbob(delta)

func _update_weapon_sway(delta):
	var target_rot = Vector3(
		-sway_target.y * sway_amount,
		-sway_target.x * sway_amount,
		0
	)

	arms.rotation = arms.rotation.lerp(
		arms_start_rot + target_rot,
		delta * sway_speed
	)

	sway_target = sway_target.lerp(
		Vector2.ZERO,
		delta * sway_speed
	)

func _update_headbob(delta):
	var speed = Vector2(
		velocity.x,
		velocity.z
	).length()

	if is_on_floor() and speed > 0.1:
		bob_time += delta * speed

		var x_bob = cos(bob_time * bob_frequency * 0.5) * bob_amplitude * 0.5
		var y_bob = sin(bob_time * bob_frequency) * bob_amplitude

		camera.position = camera_start_pos + Vector3(x_bob, y_bob, 0)

		arms.position = arms_start_pos + Vector3(
			x_bob * 0.5,
			y_bob * 0.7,
			0
		)
	else:
		camera.position = camera.position.lerp(
			camera_start_pos,
			delta * 10.0
		)

		arms.position = arms.position.lerp(
			arms_start_pos,
			delta * 10.0
		)

		bob_time = 0.0

func _try_apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y -= gravity * delta

func _handle_movement():
	var speed = walk_speed
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
		
	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)

	var direction = (
		transform.basis *
		Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if !step_stream_player.playing and velocity.length() > 0.1:
		step_stream_player.play()
