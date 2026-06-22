class_name BulletResult
extends Control

signal complete
signal type_chosen(type: ProjectileTypeManager.ProjectileType)

@export var bullet_type: ProjectileTypeManager.ProjectileType

@export var bullet_type_texture: Dictionary[ProjectileTypeManager.ProjectileType, Texture2D]

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var icon_rect: TextureRect = %IconRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bullet_displays = {
	ProjectileTypeManager.ProjectileType.Regular: {
		"title": "Regular Bullet",
		"desc": "A plain old bullet."
	},
	ProjectileTypeManager.ProjectileType.TripleShot: {
		"title": "Triple Shot Bullet",
		"desc": "A magical bullet that splits into 3!"
	},
	ProjectileTypeManager.ProjectileType.Explosive: {
		"title": "Explosive Bullet",
		"desc": "A magical bullet that explodes on impact!"
	},
	ProjectileTypeManager.ProjectileType.SpeedStim: {
		"title": "Speed Stim Bullet",
		"desc": "A magical bullet that provides its target with added speed?"
	},
	ProjectileTypeManager.ProjectileType.Healing: {
		"title": "Healing Bullet",
		"desc": "A magical bullet that heals its target?"
	},
	ProjectileTypeManager.ProjectileType.Empty: {
		"title": "No Bullet",
		"desc": "Isn't it obvious?"
	}
}

func _ready() -> void:
	# bullet_type = ProjectileTypeManager.ProjectileType.get(ProjectileTypeManager.ProjectileType.keys().pick_random())
	type_chosen.emit(bullet_type)

	title_label.text = bullet_displays[bullet_type].title
	description_label.text = bullet_displays[bullet_type].desc
	icon_rect.texture = bullet_type_texture[bullet_type]
	animation_player.play("enter")

func emit_complete():
	complete.emit()
