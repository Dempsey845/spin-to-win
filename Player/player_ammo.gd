class_name PlayerAmmo
extends Node

var max_ammo: int = 6
var current_ammo: int = 6

func _ready() -> void:
    current_ammo = max_ammo