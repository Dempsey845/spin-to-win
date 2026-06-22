extends Node

@export var ammo: PlayerAmmo
@export var gun_state: PlayerGunState
@export var hand_hitbox_manager: PlayerHandHitboxManager
@export var punch_state: PlayerPunchState

var upgrade_control: UpgradeControl

var damage: int = 1

func _ready() -> void:
	# upgrade_control.upgrade_claimed.connect(_on_upgrade_claimed)
	pass

func _on_upgrade_claimed(upgrade_type: UpgradeOption.UpgradeType):
	match upgrade_type:
		UpgradeOption.UpgradeType.DeepPockets:
			ammo.max_ammo += 1
		UpgradeOption.UpgradeType.FastDraw:
			gun_state.upgrade_fire_rate()
		UpgradeOption.UpgradeType.Grit:
			damage += 1
			gun_state.damage = damage
			hand_hitbox_manager.damage = damage
		UpgradeOption.UpgradeType.Haymaker:
			punch_state.upgrade_punch_rate()
