extends Node

var round_length_s := 20.0

var minigame_over := false

var player_scores: Array[int] = [0, 0]
var score_adds: Array[int] = [0, 0]

class SceneInfo:
    var name: String
    var instruction: String
    var music: AudioStreamPlayer
    var time_s: float

    func _init(_name: String, _instruction: String, _music: AudioStreamPlayer, _time_s: float):
        self.name = _name
        self.instruction = _instruction
        self.music = _music
        self.time_s = _time_s

@onready var scenes: Array[SceneInfo] = [
    SceneInfo.new("start", "", $StartScreenMusic, -1),
    SceneInfo.new("transition_room", "", $TransitionMusic, -1),
    SceneInfo.new("tug", "Tug!", $TugMusic, 22.0),
    SceneInfo.new("transition_room", "", $TransitionMusic, -1),
    SceneInfo.new("clean_floor", "Lick!", $CleanFloorMusic, 22.0),
    SceneInfo.new("transition_room", "", $TransitionMusic, -1),
    SceneInfo.new("tennis", "Fetch!", $TennisMusic, 22.0),
    SceneInfo.new("transition_room", "", $TransitionMusic, -1),
    SceneInfo.new("whack_a_mole", "Kill!", $WhackMusic, 22.0),
    SceneInfo.new("transition_room", "", $TransitionMusic, -1),
]

var curr_scene_idx := 0

func play_bg_music() -> void:
    if curr_scene_idx >= 1:
        scenes[curr_scene_idx - 1].music.stop()
    scenes[curr_scene_idx].music.play()

func curr_scene_time() -> float:
    return scenes[curr_scene_idx].time_s

func is_last_scene() -> bool:
    return curr_scene_idx == scenes.size() - 1

func next_scene() -> void:
    await _run_transition(0.0, 1.0)
    curr_scene_idx += 1
    if curr_scene_idx >= scenes.size():
        get_tree().quit()
    else:
        get_tree().change_scene_to_file("res://scenes/%s.tscn" % scenes[curr_scene_idx].name)

func _run_transition(from: float, to: float) -> void:
    var total_time := 2.0
    var transition = get_node_or_null("/root/SceneRoot/CanvasLayer/Transition")
    if transition != null:
        transition.material.set_shader_parameter("progress", from)
        create_tween().tween_property(transition.material, "shader_parameter/progress", to, total_time)
        await get_tree().create_timer(total_time).timeout
    

# crosscheck_name for running scenes out-of-order: fast forwards to that scene
func start_scene(crosscheck_name: String = "") -> void:
    if crosscheck_name != "":
        curr_scene_idx = scenes.find_custom(func (s): return s.name == crosscheck_name)
        assert(curr_scene_idx >= 0)
    play_bg_music()
    await _run_transition(1.0, 0.0)

func add_score(score: int, player: Utils.PlayerType) -> void:
    score_adds[player] += score

func get_transition_instruction_text() -> String:
    if curr_scene_idx + 1 >= scenes.size():
        return "Game Over!"
    return scenes[curr_scene_idx + 1].instruction
