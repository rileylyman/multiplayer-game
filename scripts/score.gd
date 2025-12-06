extends Label

@onready var left_add: Label = $LeftAdd
@onready var right_add: Label = $RightAdd

func _ready() -> void:
    set_main_text()
    set_sub_texts()

func add_scores() -> void:
    _tick_up(0)
    _tick_up(1)

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
    while GameManager.score_adds[idx] > 0:
        GameManager.player_scores[idx] += 1
        GameManager.score_adds[idx] -= 1
        set_main_text()
        set_sub_texts()
        await get_tree().create_timer(0.1).timeout
