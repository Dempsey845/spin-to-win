class_name UpgradeOption
extends Control

enum UpgradeType
{
    FastDraw,
    Grit,
    DeepPockets,
    Haymaker
}

@onready var title_label: Label = %TitleLabel
@onready var desc_label: Label = %DescLabel
@onready var expression_label: Label = %ExpressionLabel
@onready var claim_button: Button = %ClaimButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

static var upgrade_type_details = {
    UpgradeType.FastDraw: {
        "title": "Fast Draw",
        "desc": "Increase your firerate by a whopping 10%",
        "expression": "Yippee!",
        "increase": 10
    },
    UpgradeType.Grit: {
        "title": "Grit",
        "desc": "Toughen up and gain 10% more health",
        "expression": "Yee-Haw!",
        "increase": 10
    },
    UpgradeType.DeepPockets: {
        "title": "Deep Pockets",
        "desc": "Carry more ammo into the fight",
        "expression": "Yahoo!",
        "increase": 1
    },
    UpgradeType.Haymaker: {
        "title": "Haymaker",
        "desc": "Throw punches 10% faster then before",
        "expression": "All hat and all cattle?",
        "increase": 10
    }
}

var out_directions = {
    "top": "bottom",
    "bottom": "top"
}
var out_direction: String

func init(upgrade_type: UpgradeType, start_position: String, on_claim: Callable):
    title_label.text = upgrade_type_details[upgrade_type].title
    desc_label.text = upgrade_type_details[upgrade_type].desc
    expression_label.text = upgrade_type_details[upgrade_type].expression

    animation_player.play("start_" + start_position)
    
    out_direction = out_directions[start_position]

    claim_button.pressed.connect(on_claim.bind(upgrade_type))

func play_out_animation():
    claim_button.disabled = true
    animation_player.play_backwards("start_" + out_direction)
