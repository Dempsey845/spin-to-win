class_name PlayerAmmo
extends Node

static var instance: PlayerAmmo

@export var ammo_label: Label

var max_ammo: int = 16

var _current_ammo: int = 16
var current_ammo: int:
    get():
        return _current_ammo
    set(value):
        _current_ammo = value
        ammo_label.text = "%d/%d" % [value, max_ammo]
    
func _ready() -> void:
    instance = self