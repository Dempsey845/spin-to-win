extends State

@export var npc: NPC
@export var target_manager: NPCTargetManager

func enter():
    npc.speed_multiplier = 1.0
    target_manager.clear_target()
    npc.move = false
