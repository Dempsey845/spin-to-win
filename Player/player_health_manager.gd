extends Node

@onready var health: Health = $"../Health"

func _ready() -> void:
	health.damage_taken.connect(_on_health_damage_taken)

func _on_health_damage_taken(_damage_amount: int):
	print("Player: Damage taken!")
