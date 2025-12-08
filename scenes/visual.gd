extends Node2D

@onready var back  = $back
@onready var mid   = $mid
@onready var front = $front
@onready var ap    = $AnimationPlayer

var current_state = ""

var state_anim_map = {
	"idle": {
		"back":  "idle",
		"mid":   "idle",
		"front": "idle"
	},
	"run": {
		"back":  "run",
		"mid":   "run",
		"front": "run"
	},
	"jump": {
		"back":  "",
		"mid":   "",
		"front": "jump"
	},
	"win": {
		"back":  "win",
		"mid":   "win",
		"front": "win"
	},
}

func play_state(state: String) -> void:
	if state == current_state:
		return
	current_state = state

	var cfg = state_anim_map.get(state)
	if cfg == null:
		return

	if state == "jump":
		back.visible = false
		mid.visible = false
		front.visible = true
		front.frame = 0
		front.play(cfg["front"])
	else:
		back.visible = true
		mid.visible = true
		front.visible = true
		back.frame = 0
		mid.frame = 0
		front.frame = 0
		back.play(cfg["back"])
		mid.play(cfg["mid"])
		front.play(cfg["front"])

	if ap != null:
		if state == "run":
			ap.play("run_motion")
		elif state == "jump":
			ap.play("jump_motion")
		else:
			ap.play("RESET")
