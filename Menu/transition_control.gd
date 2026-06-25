class_name Transition
extends Control

signal transition_complete

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func start_transition():
    animation_player.play("start")

func emit_transition_complete():
    transition_complete.emit()