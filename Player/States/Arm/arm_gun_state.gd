extends State

@export var ammo: PlayerAmmo
@export var animation_manager: PlayerAnimationManager
@export var shoot_ray: RayCast3D
@export var punch_state: State
@export var gun_visual: Node3D
@export var revolver_spawn_point: Marker3D
@export var revolver_manager: PlayerRevolverManager
@export var projectile_fire_point: Marker3D
@export var projectile_type_manager: ProjectileTypeManager

var revolver_scene: PackedScene = preload("uid://mettisjl70wh")
var explosion_scene: PackedScene = preload("uid://swu7vpjkvba7")
var heal_particle_effect_scene: PackedScene = preload("uid://b1afg8t2ww1tg")
var speed_particle_effect_scene: PackedScene = preload("uid://bdgpgqqu06iya")

var can_shoot: bool = true
var can_equip_punch: bool = true

func enter():
	gun_visual.visible = true

	can_equip_punch = true

	animation_manager.set_arm_state_machine_condition("pistol_idle", true)

	animation_manager.shoot_animation_started.connect(_on_shoot_animation_started)
	animation_manager.shoot_animation_ended.connect(_on_shoot_animation_ended)

	animation_manager.equip_punch_ended.connect(func(): 
		state_machine.change_state(punch_state)
	)

func update(_delta: float):
	if ammo.current_ammo > 0 and Input.is_action_just_pressed("shoot") and can_shoot:
		_shoot()
	elif can_equip_punch:
		if Input.is_action_just_pressed("equip"):
			_equip_punch()
		elif Input.is_action_just_pressed("throw"):
			_throw_revolver()

func _throw_revolver():
	gun_visual.visible = false

	var revolver = revolver_scene.instantiate()
	get_tree().current_scene.add_child(revolver)

	revolver.global_position = revolver_spawn_point.global_position
	revolver.global_rotation = revolver_spawn_point.global_rotation
	revolver.init_force()
	
	revolver_manager.drop()

	_equip_punch()

func _equip_punch():
	can_equip_punch = false
	animation_manager.set_arm_state_machine_condition("equip_punch", true)
	animation_manager.set_arm_state_machine_condition("pistol_idle", false)

func _shoot():
	if projectile_type_manager.current_projectile_type == ProjectileTypeManager.ProjectileType.Empty:
		ammo.current_ammo = 0
		return

	animation_manager.set_arm_state_machine_condition("shoot", true)
	can_shoot = false
	ammo.current_ammo -= 1

	# shoot_ray.force_raycast_update()

	# if shoot_ray.is_colliding():
	# 	var target: Node3D = shoot_ray.get_collider()
	# 	var hit_pos: Vector3 = shoot_ray.get_collision_point()

	# 	if target is Hurtbox:
	# 		var hurtbox: Hurtbox = target
	# 		hurtbox.register_hit(1)

	# 	print("Hit:", target.name)
	# 	print("Position:", hit_pos)

	if projectile_type_manager.current_projectile_type == ProjectileTypeManager.ProjectileType.TripleShot:
		var spread_degrees := 2.5

		for angle in [-spread_degrees, 0.0, spread_degrees]:
			_spawn_projectile(angle)
	else:
		_spawn_projectile(0.0)

func _spawn_projectile(spread_angle: float):
	var projectile: Projectile = projectile_type_manager.get_current_projectile_scene().instantiate()

	get_tree().current_scene.add_child(projectile)

	projectile.global_position = projectile_fire_point.global_position
	projectile.global_rotation = projectile_fire_point.global_rotation

	projectile.rotate_y(deg_to_rad(spread_angle))

	if projectile_type_manager.current_projectile_type == ProjectileTypeManager.ProjectileType.Explosive:
		projectile.on_hit_callable = explode_projectile
	elif projectile_type_manager.current_projectile_type == ProjectileTypeManager.ProjectileType.SpeedStim:
		projectile.on_hit_callable = speed_up_enemy
	elif projectile_type_manager.current_projectile_type == ProjectileTypeManager.ProjectileType.Healing:
		projectile.on_hit_callable = heal_enemy
		projectile.damage = 0


func explode_projectile(_body: Node, hit_position: Vector3):
	var explosion = explosion_scene.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = hit_position

func speed_up_enemy(body: Node, hit_position: Vector3):
	if body.get_parent() is NPC:
		var npc: NPC = body.get_parent()
		npc.speed_multiplier += 0.5
		npc.hit_cooldown_time = 4.0
		var speed_particle_effect = speed_particle_effect_scene.instantiate()
		get_tree().current_scene.add_child(speed_particle_effect)
		speed_particle_effect.global_position = hit_position
		await get_tree().create_timer(15.0).timeout
		if is_instance_valid(npc):
			npc.speed_multiplier -= 0.5
			npc.hit_cooldown_time = 0.1

func heal_enemy(body: Node, hit_position: Vector3):
	if body.get_parent() is NPC:
		var npc: NPC = body.get_parent()
		var npc_health: Health = npc.get_node("Health")
		var heal_particle_effect = heal_particle_effect_scene.instantiate()
		get_tree().current_scene.add_child(heal_particle_effect)
		heal_particle_effect.global_position = hit_position
		npc_health.heal(2) # TODO: Replace with damage * 2

func exit():
	gun_visual.visible = false

	animation_manager.set_arm_state_machine_condition("equip_punch", false)
	animation_manager.set_arm_state_machine_condition("pistol_idle", false)

	animation_manager.shoot_animation_started.disconnect(_on_shoot_animation_started)
	animation_manager.shoot_animation_ended.disconnect(_on_shoot_animation_ended)

func _on_shoot_animation_started():
	animation_manager.set_arm_state_machine_condition("shoot", false)

func _on_shoot_animation_ended():
	can_shoot = true
