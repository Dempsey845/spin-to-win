extends Node

@export var health_bar: ProgressBar
@export var delayed_health_bar: ProgressBar

@export var state_machine: StateMachine
@export var death_state: State

@onready var health: Health = $"../Health"
@onready var heal_player: AudioStreamPlayer = $HealPlayer

var delayed_tween: Tween

func _ready() -> void:
	health.damage_taken.connect(_on_health_damage_taken)
	health.health_changed.connect(_on_health_changed)
	health.max_health_changed.connect(_on_max_health_changed)
	_on_max_health_changed(health.max_health)
	health.death.connect(_on_health_death)
	health.healed.connect(func(_heal_amount: int):
		heal_player.play()
	)

func _on_health_damage_taken(_damage_amount: int):
	pass


func _on_health_changed(new_health: int, _change_amount: int):
	health_bar.value = new_health
	if delayed_tween:
		delayed_tween.kill()

	var current_delayed = delayed_health_bar.value

	if new_health < current_delayed:
		delayed_tween = create_tween()
		delayed_tween.tween_interval(0.4)
		delayed_tween.tween_property(delayed_health_bar, "value", new_health, 0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
	else:
		delayed_tween = create_tween()
		delayed_tween.tween_property(delayed_health_bar, "value", new_health, 0.25)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)

func _on_max_health_changed(new_max_health: int):
	health_bar.max_value = new_max_health
	delayed_health_bar.max_value = new_max_health

func _on_health_death():
	state_machine.change_state(death_state)