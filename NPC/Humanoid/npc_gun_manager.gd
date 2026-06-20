extends Node

@export var revolver_visual: Node3D
@export var hand_attachment_slot: Node3D

func equip_revolver():
    revolver_visual.reparent(hand_attachment_slot)
    revolver_visual.position = Vector3.ZERO
    revolver_visual.rotation = Vector3.ZERO