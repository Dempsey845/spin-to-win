extends State

@export var animation_manager: PlayerAnimationManager
@export var shoot_ray: RayCast3D
@export var punch_state: State
@export var gun_visual: Node3D

var can_shoot: bool = true
var can_equip_punch: bool = true

func enter():
	gun_visual.visible = true
	
	can_equip_punch = true

	animation_manager.set_arm_state_machine_condition("pistol_idle", true)

	animation_manager.shoot_animation_started.connect(_on_shoot_animation_started)
	animation_manager.shoot_animation_ended.connect(_on_shoot_animation_ended)

	animation_manager.equip_punch_ended.connect(func(): 
		animation_manager.set_arm_state_machine_condition("equip_punch", false)
		state_machine.change_state(punch_state)
	)

func update(_delta: float):
	if Input.is_action_just_pressed("shoot") and can_shoot:
		animation_manager.set_arm_state_machine_condition("shoot", true)
		can_shoot = false
		shoot()
	elif Input.is_action_just_pressed("equip") and can_equip_punch:
		can_equip_punch = false
		animation_manager.set_arm_state_machine_condition("equip_punch", true)
		animation_manager.set_arm_state_machine_condition("pistol_idle", false)

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
	gun_visual.visible = false

	animation_manager.set_arm_state_machine_condition("pistol_idle", false)

	animation_manager.shoot_animation_started.disconnect(_on_shoot_animation_started)
	animation_manager.shoot_animation_ended.disconnect(_on_shoot_animation_ended)

func _on_shoot_animation_started():
	animation_manager.set_arm_state_machine_condition("shoot", false)

func _on_shoot_animation_ended():
	can_shoot = true
