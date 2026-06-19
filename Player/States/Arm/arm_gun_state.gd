extends State

@export var animation_manager: PlayerAnimationManager
@export var shoot_ray: RayCast3D

var can_shoot: bool = true

func enter():
	animation_manager.set_arm_state_machine_condition("pistol_idle", true)

	animation_manager.shoot_animation_started.connect(_on_shoot_animation_started)
	animation_manager.shoot_animation_ended.connect(_on_shoot_animation_ended)

func update(_delta: float):
	if Input.is_action_just_pressed("shoot") and can_shoot:
		animation_manager.set_arm_state_machine_condition("shoot", true)
		can_shoot = false
		shoot()

func shoot():
	shoot_ray.force_raycast_update()

	if shoot_ray.is_colliding():
		var target: Node3D = shoot_ray.get_collider()
		var hit_pos: Vector3 = shoot_ray.get_collision_point()

		if target is Hurtbox:
			var hurtbox: Hurtbox = target
			hurtbox.register_hit(1)

		print("Hit:", target.name)
		print("Position:", hit_pos)

func exit():
	animation_manager.set_arm_state_machine_condition("pistol_idle", false)

	animation_manager.shoot_animation_started.disconnect(_on_shoot_animation_started)
	animation_manager.shoot_animation_ended.disconnect(_on_shoot_animation_ended)

func _on_shoot_animation_started():
	animation_manager.set_arm_state_machine_condition("shoot", false)

func _on_shoot_animation_ended():
	can_shoot = true
