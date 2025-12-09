extends AnimationPlayer

@export var instruction: Label
@export var score: Label

@export var left_crown: Sprite2D
@export var right_crown: Sprite2D

func _ready() -> void:
    instruction.text = GameManager.get_transition_instruction_text()
    var needs_score_tick: bool = GameManager.score_adds[0] > 0 or GameManager.score_adds[1] > 0
    score.adds_visible(needs_score_tick)

    if not GameManager.is_last_scene():
        left_crown.visible = GameManager.score_adds[0] > GameManager.score_adds[1]
        right_crown.visible = GameManager.score_adds[1] > GameManager.score_adds[0]
    else:
        left_crown.visible = GameManager.score_adds[0] + GameManager.player_scores[0] >= GameManager.score_adds[1] + GameManager.player_scores[1]
        right_crown.visible = GameManager.score_adds[1] + GameManager.player_scores[1] >= GameManager.score_adds[0] + GameManager.player_scores[0]

    GameManager.start_scene()
    play("up")
    await animation_finished
    if needs_score_tick:
        await score.add_scores()
        await get_tree().create_timer(1.5).timeout
    
    if not GameManager.is_last_scene():
        play("down")
        await animation_finished
        GameManager.next_scene()
    else:
        play("down_lite")

