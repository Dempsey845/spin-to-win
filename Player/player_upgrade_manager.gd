class_name PlayerUpgradeManager
extends Node

@export var wave_manager: PlayerWaveManager
@export var ammo: PlayerAmmo
@export var gun_state: PlayerGunState
@export var hand_hitbox_manager: PlayerHandHitboxManager
@export var punch_state: PlayerPunchState
@export var health: Health

var damage: int = 1

func claim_upgrade(upgrade_type: UpgradeOption.UpgradeType):
	match upgrade_type:
		UpgradeOption.UpgradeType.DeepPockets:
			ammo.max_ammo += 6
		UpgradeOption.UpgradeType.FastDraw:
			gun_state.upgrade_fire_rate()
		UpgradeOption.UpgradeType.Grit:
			health.max_health += max(1, roundi(health.max_health * 0.10))
		UpgradeOption.UpgradeType.Haymaker:
			punch_state.upgrade_punch_rate()
		UpgradeOption.UpgradeType.HeavyHitter:
			damage += max(1, roundi(damage * 0.20))
			gun_state.damage = damage
			hand_hitbox_manager.damage = damage
