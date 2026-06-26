extends State

@export var player_animation_player: AnimationPlayer
@export var arms_animation_tree: AnimationTree
@export var transition_control: Transition

func enter():
    if transition_control.transition_complete.is_connected(_on_transition_complete):
        return

    transition_control.transition_complete.connect(_on_transition_complete)

    arms_animation_tree.set("parameters/DeathOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    player_animation_player.play("death")

    await get_tree().create_timer(2.5).timeout
    
    transition_control.start_transition()

func _on_transition_complete():
    var load_result: int = get_tree().change_scene_to_file("uid://byl0t7f715o3c")

    while load_result != OK:
        push_warning("Failed to change scene. Trying again in 1 second.")
        await get_tree().create_timer(1.0).timeout
        load_result = get_tree().change_scene_to_file("uid://byl0t7f715o3c")