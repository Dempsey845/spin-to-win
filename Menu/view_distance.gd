class_name ViewDistance
extends HBoxContainer

@onready var slider: HSlider = $SliderValue/Slider
@onready var value_label: Label = $SliderValue/Value

func _ready() -> void:
    slider.value_changed.connect(_on_value_changed)

func _on_value_changed(value: float):
    value_label.text = "%dm" % int(value)

    if MainCamera.instance:
        MainCamera.instance.far = value