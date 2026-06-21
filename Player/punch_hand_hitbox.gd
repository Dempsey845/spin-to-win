extends Hitbox

@export var player: Player

func _ready() -> void:
	super._ready()
	hit_hurtbox.connect(_on_punch_hit_hurtbox)
	knockback = false

func _on_punch_hit_hurtbox(hurtbox: Hurtbox):
	if hurtbox.get_parent() is NPC:
		var npc: NPC = hurtbox.get_parent()
		npc.apply_knockback(global_position, 7.0, 2.0)