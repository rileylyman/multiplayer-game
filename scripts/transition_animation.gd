extends AnimationPlayer

@export var instruction: Label
@export var score: Label

func _ready() -> void:
    instruction.text = GameManager.get_transition_instruction_text()
    var needs_score_tick := GameManager.score_adds[0] > 0 or GameManager.score_adds[1] > 0
    score.adds_visible(needs_score_tick)

    GameManager.start_scene()
    play("up")
    await animation_finished
    if needs_score_tick:
        await score.add_scores()
        await get_tree().create_timer(1.5).timeout
    play("down")
    await animation_finished
    GameManager.next_scene()
