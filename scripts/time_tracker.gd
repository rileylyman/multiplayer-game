extends Control

@onready var total_time_s := GameManager.round_length_s
@onready var fore: ColorRect = $Fg

var time_s := 0.0
var _over := false

func _ready() -> void:
    GameManager.start_scene()

func _process(delta: float) -> void:
    time_s += delta
    fore.custom_minimum_size.x = get_viewport_rect().size.x * (1 - time_s / total_time_s)

    if not _over and time_s >= total_time_s:
        _over = true
        GameManager.next_scene()
