class_name PlayerUpgradeManager
extends Node

@export var wave_manager: PlayerWaveManager
@export var ammo: PlayerAmmo
@export var gun_state: PlayerGunState
@export var hand_hitbox_manager: PlayerHandHitboxManager
@export var punch_state: PlayerPunchState

var damage: int = 1

func claim_upgrade(upgrade_type: UpgradeOption.UpgradeType):
	match upgrade_type:
		UpgradeOption.UpgradeType.DeepPockets:
			ammo.max_ammo += 6
		UpgradeOption.UpgradeType.FastDraw:
			gun_state.upgrade_fire_rate()
		UpgradeOption.UpgradeType.Grit:
			damage += 1
			gun_state.damage = damage
			hand_hitbox_manager.damage = damage
		UpgradeOption.UpgradeType.Haymaker:
			punch_state.upgrade_punch_rate()
