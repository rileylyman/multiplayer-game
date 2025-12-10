class_name TennisPlayer extends CharacterBody2D

@export var player := Utils.PlayerType.PLAYER_1
@export var speed := 300.0

@onready var other_player: TennisPlayer = $"/root/SceneRoot/TennisPlayer2" if player == Utils.PlayerType.PLAYER_1 else $"/root/SceneRoot/TennisPlayer"
@onready var sprite: Sprite2D = $Sprite2D
@onready var visual_p1: Node2D = $VisualP1
@onready var visual_p2: Node2D = $VisualP2
@onready var sfx_step: AudioStreamPlayer2D = $SFX_step

var front: AnimatedSprite2D
var mid: AnimatedSprite2D
var back: AnimatedSprite2D
var ap: AnimationPlayer

var move_state := "idle"
var mid_is_hitting := false

var ball: TennisBall = null

func _ready() -> void:
	if player == Utils.PlayerType.PLAYER_1:
		visual_p1.visible = true
		visual_p2.visible = false
		front = visual_p1.get_node("front")
		mid = visual_p1.get_node("mid")
		back = visual_p1.get_node("back")
		ap = visual_p1.get_node("AnimationPlayer")
	else:
		visual_p1.visible = false
		visual_p2.visible = true
		front = visual_p2.get_node("front")
		mid = visual_p2.get_node("mid")
		back = visual_p2.get_node("back")
		ap = visual_p2.get_node("AnimationPlayer")

	mid.animation_finished.connect(_on_mid_animation_finished)

	front.play("idle")
	mid.play("idle")
	back.play("idle")
	ap.play("RESET")
	
func _get_hit_to_point() -> Vector2:
	var wssr = Utils.wssr()
	var buffer := 200.0
	# var x
	# if global_position.x < 0:
	#     x = randf_range(buffer, wssr.end.x - buffer)
	# else:
	#     x = randf_range(wssr.position.x + buffer, -buffer)
	var x = randf_range(other_player.global_position.x - buffer, other_player.global_position.x + buffer)
	var y = randf_range(other_player.global_position.y - buffer, other_player.global_position.y + buffer)
	var ret = Vector2(x, y)
	var margin := Vector2(50.0, 150.0)
	var p1 = wssr.position + margin
	var p2 = wssr.end - margin
	return ret.clamp(p1, p2)
	
func set_move_state(state: String) -> void:
	if state == move_state:
		return
	move_state = state
	if state == "idle":
		front.play("idle")
		back.play("idle")
		if not mid_is_hitting:
			mid.play("idle")
		ap.play("RESET")
	elif state == "run":
		front.play("run")
		back.play("run")
		if not mid_is_hitting:
			mid.play("run")
		ap.play("run_motion")

func play_hit() -> void:
	mid_is_hitting = true
	mid.stop()
	mid.frame = 0
	mid.play("hit")

func _on_mid_animation_finished() -> void:
	if mid.animation == "hit":
		mid_is_hitting = false
		if move_state == "run":
			mid.play("run")
		else:
			mid.play("idle")
			
func play_step_sfx():
	$SFX_step.play()
	
func _physics_process(_delta: float) -> void:
	var move_vector = Utils.get_player_move_vector("move_left", "move_right", "move_up", "move_down", player)
	var desired = speed * move_vector
	velocity = velocity.lerp(desired, 0.1)
	move_and_slide()
	_clamp_pos_to_screen()
	var new_state := move_state
	if move_vector.length() > 0.1:
		new_state = "run"
	else:
		new_state = "idle"
	if new_state != move_state:
		set_move_state(new_state)

	if Utils.is_player_action_just_pressed("button1", player):
		play_hit()
		if ball != null and ball.is_near_ground():
			ball.global_position = global_position
			ball.hit_towards(_get_hit_to_point())
			GameManager.add_score(19, player)

func _clamp_pos_to_screen() -> void:
	var screen_rect = Utils.get_global_viewport_rect()
	var sprite_rect = Utils.get_sprite_global_rect(sprite)
	global_position = global_position.clamp(screen_rect.position + sprite_rect.size / 2, screen_rect.end - sprite_rect.size / 2)
