extends Node

var round_length_s := 20.0

var minigame_over := false

var player_scores: Array[int] = [0, 0]
var score_adds: Array[int] = [0, 0]

var scenes = [
    ["start"],
    ["transition_room"],
    ["clean_floor", "Lick!"],
    ["transition_room"],
    ["tug", "Tug!"],
    ["transition_room"],
    ["tennis", "Fetch!"],
    ["transition_room"],
    ["whack_a_mole", "Kill!"],
    ["transition_room"],
]

var curr_scene_idx := 0

func next_scene() -> void:
    await _run_transition(0.0, 1.0)
    curr_scene_idx += 1
    if curr_scene_idx >= scenes.size():
        get_tree().quit()
    else:
        get_tree().change_scene_to_file("res://scenes/%s.tscn" % scenes[curr_scene_idx][0])

func _run_transition(from: float, to: float) -> void:
    var total_time := 2.0
    var transition = get_node_or_null("/root/SceneRoot/CanvasLayer/Transition")
    if transition != null:
        transition.material.set_shader_parameter("progress", from)
        create_tween().tween_property(transition.material, "shader_parameter/progress", to, total_time)
        await get_tree().create_timer(total_time).timeout
    

func start_scene() -> void:
    await _run_transition(1.0, 0.0)

func add_score(score: int, player: Utils.PlayerType) -> void:
    score_adds[player] += score

func get_transition_instruction_text() -> String:
    if curr_scene_idx + 1 >= scenes.size():
        return "Game Over!"
    return scenes[curr_scene_idx + 1][1]
