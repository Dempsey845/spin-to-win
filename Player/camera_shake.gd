class_name CameraShake
extends Node

@export var camera_pivots: Array[Node3D]

var shake_strength: float = 0.0
var shake_decay: float = 5.0

var pos_strength: float = 0.15
var rot_strength: float = 2.5

var noise: FastNoiseLite = FastNoiseLite.new()
var time: float = 0.0

var base_positions: Dictionary = {}
var base_rotations: Dictionary = {}

func _ready():
    noise.seed = randi()
    noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
    noise.frequency = 2.0

    for pivot in camera_pivots:
        if pivot == null:
            continue

        base_positions[pivot] = pivot.position
        base_rotations[pivot] = pivot.rotation_degrees


func _process(delta):
    time += delta

    shake_strength = lerp(shake_strength, 0.0, shake_decay * delta)

    var n1 = noise.get_noise_2d(time * 10.0, 0.0)
    var n2 = noise.get_noise_2d(0.0, time * 10.0)
    var n3 = noise.get_noise_2d(time * 10.0, time * 10.0)

    var shake_factor = shake_strength

    var position_offset = Vector3(n1, n2, n3) * pos_strength * shake_factor
    var rotation_offset = Vector3(n2, n1, n3) * rot_strength * shake_factor

    for pivot in camera_pivots:
        if pivot == null:
            continue

        pivot.position = base_positions[pivot] + position_offset
        pivot.rotation_degrees = base_rotations[pivot] + rotation_offset


func add_shake(amount: float):
    shake_strength = max(shake_strength, amount)