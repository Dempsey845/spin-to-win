extends State

@export var punch_state: State
@export var shoot_state: State

func enter():
    var random_state = [punch_state, punch_state, shoot_state].pick_random()

    state_machine.change_state(random_state)