extends Label

@onready var left_add: Label = $LeftAdd
@onready var right_add: Label = $RightAdd

func _ready() -> void:
    set_main_text()
    set_sub_texts()

func adds_visible(visible: bool) -> void:
    left_add.visible = visible
    right_add.visible = visible

func add_scores() -> void:
    if GameManager.score_adds[0] > GameManager.score_adds[1]:
        _tick_up(1)
        await _tick_up(0)
    else:
        _tick_up(0)
        await _tick_up(1)

# func _process(delta: float) -> void:
#     if GameManager.score_adds[0] == 0:
#         left_add.visible = false
#     if GameManager.score_adds[1] == 0:
#         right_add.visible = false

func set_main_text() -> void:
    text = "%d   -   %d" % GameManager.player_scores

func set_sub_texts() -> void:
    left_add.text = "+%d" % GameManager.score_adds[0]
    right_add.text = "+%d" % GameManager.score_adds[1]

func _tick_up(idx: int) -> void:
    var interval = min(0.1, 1.5 / GameManager.score_adds[idx])
    while GameManager.score_adds[idx] > 0:
        GameManager.player_scores[idx] += 1
        GameManager.score_adds[idx] -= 1
        set_main_text()
        set_sub_texts()
        await get_tree().create_timer(interval).timeout
