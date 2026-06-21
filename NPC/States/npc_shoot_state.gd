extends State

@export var npc: NPC
@export var target_manager: NPCTargetManager
@export var humanoid: NPCHumanoid
@export var health: Health

@onready var shoot_cooldown_timer: Timer = $ShootCooldownTimer
@onready var hit_cooldown_timer: Timer = $HitCooldownTimer

var playing_hit_animation: bool
var playing_shoot_animation: bool

func enter():
    shoot_cooldown_timer.start()

    humanoid.stop_upper_body_blend.call_deferred(func():
        var player: Player = get_tree().get_first_node_in_group("player")
        target_manager.set_target(player)
        npc.move = true
        humanoid.get_node("GunManager").equip_revolver()
    , 0.25)

    health.damage_taken.connect(_on_health_damage_taken)
    humanoid.hit_animation_complete.connect(_on_hit_animation_complete)
    humanoid.shoot_animation_complete.connect(_on_shoot_animation_complete)

    hit_cooldown_timer.wait_time = npc.hit_cooldown_time

func update(_delta: float):
    if shoot_cooldown_timer.is_stopped() and !playing_hit_animation:
        shoot()
        shoot_cooldown_timer.start()

func exit():
    playing_hit_animation = false
    playing_shoot_animation = false

    shoot_cooldown_timer.stop()

    health.damage_taken.disconnect(_on_health_damage_taken)
    humanoid.hit_animation_complete.disconnect(_on_hit_animation_complete)
    humanoid.shoot_animation_complete.disconnect(_on_shoot_animation_complete)

func shoot():
    npc.move = false
    playing_shoot_animation = true
    humanoid.play_one_shot("Shoot")

func _on_health_damage_taken(damage_amount: int):
    if playing_hit_animation or damage_amount < 1:
        return

    if !hit_cooldown_timer.is_stopped():
        return
    
    hit_cooldown_timer.wait_time = npc.hit_cooldown_time
    hit_cooldown_timer.start()

    if playing_shoot_animation:
        humanoid.abort_one_shot("Shoot")
        playing_shoot_animation = false

    npc.move = false
    playing_hit_animation = true
    humanoid.play_one_shot("Hit")

func _on_hit_animation_complete():
    playing_hit_animation = false
    npc.move = !playing_shoot_animation

func _on_shoot_animation_complete():
    playing_shoot_animation = false
    npc.move = !playing_hit_animation