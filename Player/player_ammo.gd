class_name PlayerAmmo
extends Node

static var instance: PlayerAmmo

@export var ammo_label: Label

var _max_ammo: int = 18
var max_ammo: int:
    get():
        return _max_ammo
    set(value):
        _max_ammo = value
        ammo_label.text = "%d/%d" % [current_ammo, value]

var _current_ammo: int = 18
var current_ammo: int:
    get():
        return _current_ammo
    set(value):
        _current_ammo = value
        ammo_label.text = "%d/%d" % [value, max_ammo]
    
func _ready() -> void:
    instance = self