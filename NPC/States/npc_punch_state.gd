extends State

@export var npc: NPC
@export var humanoid: NPCHumanoid
@export var health: Health
@export var target_manager: NPCTargetManager
@export var punch_distance: float = 1.5

@onready var punch_cooldown_timer: Timer = $PunchCooldownTimer
@onready var hit_cooldown_timer: Timer = $HitCooldownTimer
@onready var punch_distance_sq: float = punch_distance * punch_distance

var can_punch: bool
var punch_animations: Array[String] = ["punch_cross"]

func enter():
	humanoid.start_upper_body_blend.call_deferred(func():
		humanoid.play_upper_body_animation("punch_idle")
		punch_cooldown_timer.start()
		can_punch = true

		var player: Player = get_tree().get_first_node_in_group("player")

		target_manager.set_target(player)
		npc.move = true
	, 0.25)

	hit_cooldown_timer.wait_time = npc.hit_cooldown_time

	health.damage_taken.connect(_on_health_damage_taken)


func update(_delta: float):
	if can_punch and punch_cooldown_timer.is_stopped() and target_manager.get_distance_sq_to_target() < punch_distance_sq:
		humanoid.play_upper_body_animation(punch_animations.pick_random())
		punch_cooldown_timer.start()

func exit():
	health.damage_taken.disconnect(_on_health_damage_taken)

	target_manager.clear_target()
	npc.move = false

func _on_health_damage_taken(damage_amount: int):\
	if hit_cooldown_timer.is_stopped() and damage_amount > 0:
		humanoid.play_upper_body_animation("punch_hit")
		hit_cooldown_timer.wait_time = npc.hit_cooldown_time
		hit_cooldown_timer.start()
