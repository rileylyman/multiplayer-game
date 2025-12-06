extends Node2D

@export var player1_start: StartKey
@export var player2_start: StartKey
@export var transition: Sprite2D

var _started := false

func _process(_delta: float) -> void:
    if not _started and player1_start.is_ready and player2_start.is_ready:
        _start_game()

func _start_game() -> void:
    _started = true
    # create_tween().tween_property(transition.material, "shader_parameter/progress", 1.0, 2.0)
    # await get_tree().create_timer(3.0).timeout
    GameManager.next_scene()
