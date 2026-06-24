class_name UpgradeControl
extends Control

signal upgrade_claimed(upgrade_type: UpgradeOption.UpgradeType)

@onready var upgrade_option_container: HBoxContainer = $UpgradeOptionContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var upgrade_option_scene: PackedScene = preload("uid://cy5crojjik5wj")

var start_positions = ["top", "bottom"]

func start_upgrade():
    animation_player.play("fade_in")

func get_random_option() -> UpgradeOption.UpgradeType:
    return UpgradeOption.UpgradeType.get(UpgradeOption.UpgradeType.keys().pick_random())

func pick_random_options():
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    var random_option_one = get_random_option()
    var random_option_two = get_random_option()

    while random_option_two == random_option_one:
        random_option_two = get_random_option()
    
    start_positions.shuffle()

    create_upgrade_option(random_option_one, start_positions[0])
    create_upgrade_option(random_option_two, start_positions[1])
    
func create_upgrade_option(type: UpgradeOption.UpgradeType, start_position: String):
    var upgrade_option: UpgradeOption = upgrade_option_scene.instantiate()
    upgrade_option_container.add_child(upgrade_option)
    upgrade_option.init(type, start_position, on_upgrade_claimed)

func on_upgrade_claimed(upgrade_type: UpgradeOption.UpgradeType):
    for option: UpgradeOption in upgrade_option_container.get_children():
        option.play_out_animation()
    await get_tree().create_timer(2.0).timeout
    animation_player.play("fade_out")
    upgrade_claimed.emit(upgrade_type)

func unfreeze_and_capture():
    get_tree().paused = false
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED