class_name NPCPunchManager
extends Node

@export var punch_hitbox: Hitbox
@export var punch_raycast: RayCast3D

@export var punch_stream_player: AudioStreamPlayer3D 

func enable_hitbox():
	punch_raycast.force_raycast_update()
	if punch_raycast.is_colliding():
		var hit = punch_raycast.get_collider()
		if hit is Hurtbox:
			hit.register_hit(1)

	# punch_hitbox.active = true
	punch_stream_player.play()

func disable_hitbox():
	punch_hitbox.active = false
