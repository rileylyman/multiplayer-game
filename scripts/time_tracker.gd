extends Control

@onready var fore: ColorRect = $Fg
@onready var root: SceneID = $"/root/SceneRoot"

var total_time_s: float
var time_s := 0.0
var _over := false

func _ready() -> void:
	GameManager.start_scene(root.scene_name)
	total_time_s = GameManager.curr_scene_time()

func _process(delta: float) -> void:
	time_s += delta
	fore.custom_minimum_size.x = get_viewport_rect().size.x * (1 - time_s / total_time_s)
	fore.size.x = get_viewport_rect().size.x * (1 - time_s / total_time_s)

	if not _over and time_s >= total_time_s:
		_over = true
		GameManager.next_scene()
