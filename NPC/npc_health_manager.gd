extends Node

@export var humanoid: NPCHumanoid
@export var death_state: State

@export var hurtbox: Hurtbox
@export var hit_stream_player: AudioStreamPlayer3D
@export var death_stream_player: AudioStreamPlayer3D

@onready var state_machine: StateMachine = $'../StateMachine'
@onready var health: Health = $'../Health'

var dead: bool

func _ready() -> void:
	health.damage_taken.connect(_on_damage_taken)
	health.death.connect(_on_death)

func _on_death():
	if dead:
		return
	hurtbox.set_deferred("monitorable", false)
	state_machine.change_state(death_state)
	humanoid.play_death_animation()
	death_stream_player.play()
	dead = true

func _on_damage_taken(_damage_amount: int):
	if dead:
		return
		
	if health.current_heatlh > 0:
		hit_stream_player.play()