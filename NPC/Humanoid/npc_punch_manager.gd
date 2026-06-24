class_name NPCPunchManager
extends Node

@export var punch_hitbox: Hitbox

@onready var punch_stream_player: AudioStreamPlayer3D = $PunchStreamPlayer

func enable_hitbox():
	punch_hitbox.active = true
	punch_stream_player.play()

func disable_hitbox():
	punch_hitbox.active = false
