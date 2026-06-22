extends Node

@export var humanoid: NPCHumanoid
@export var death_state: State

@onready var state_machine: StateMachine = $'../StateMachine'
@onready var health: Health = $'../Health'

func _ready() -> void:
    health.death.connect(_on_death)

func _on_death():
    state_machine.change_state(death_state)
    humanoid.play_death_animation()