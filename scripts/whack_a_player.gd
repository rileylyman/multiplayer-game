class_name WhackAPlayer extends CharacterBody2D

@export var player := Utils.PlayerType.PLAYER_1
@export var speed := 300.0
@export var bite_duration := 0.5

@onready var other_player: WhackAPlayer = $"/root/SceneRoot/WhackAPlayer2" if player == Utils.PlayerType.PLAYER_1 else $"/root/SceneRoot/WhackAPlayer"
@onready var sprite: Sprite2D = $Sprite2D
@onready var visual_p1: Node2D = $VisualP1
@onready var visual_p2: Node2D = $VisualP2
@onready var bite_area: Area2D = (visual_p1.get_node("BiteHitbox") if player == Utils.PlayerType.PLAYER_1 else visual_p2.get_node("BiteHitbox"))
var anim_player: AnimationPlayer
@onready var sfx_step: AudioStreamPlayer2D = $SFX_step
@onready var sfx_bite: AudioStreamPlayer2D = $SFX_bite

var front: AnimatedSprite2D
var mid: AnimatedSprite2D
var back: AnimatedSprite2D

var _frozen := false
var move_state := "idle"
var mid_is_biting := false


func _ready() -> void:
	if player == Utils.PlayerType.PLAYER_1:
		visual_p1.visible = true
		visual_p2.visible = false
		front = visual_p1.get_node("front")
		mid = visual_p1.get_node("mid")
		back = visual_p1.get_node("back")
		anim_player = visual_p1.get_node("AnimationPlayer")
	else:
		visual_p1.visible = false
		visual_p2.visible = true
		front = visual_p2.get_node("front")
		mid = visual_p2.get_node("mid")
		back = visual_p2.get_node("back")
		anim_player = visual_p2.get_node("AnimationPlayer")

	front.play("idle")
	mid.play("idle")
	back.play("idle")

	mid.animation_finished.connect(_on_mid_animation_finished)

func play_step_sfx():
		$SFX_step.play()

func freeze() -> void:
	_frozen = true
	await get_tree().create_timer(bite_duration).timeout
	_frozen = false


func _physics_process(_delta: float) -> void:
	if Utils.is_player_action_just_pressed("button1", player):
		play_bite()
	if _frozen:
		return

	var move_vector = Utils.get_player_move_vector("move_left", "move_right", "move_up", "move_down", player)
	var desired = speed * move_vector
	velocity = velocity.lerp(desired, 0.1)
	move_and_slide()
	_clamp_pos_to_screen()

	var new_state = "run" if move_vector.length() > 0.1 else "idle"
	if new_state != move_state:
		set_move_state(new_state)

	if Utils.is_player_action_just_pressed("button1", player):
		play_bite()
		
	if move_vector.x > 0:
		if player == Utils.PlayerType.PLAYER_1:
			visual_p1.scale.x = 0.15
		else:
			visual_p2.scale.x = -0.15
	elif move_vector.x < 0:
		if player == Utils.PlayerType.PLAYER_1:
			visual_p1.scale.x = -0.15
		else:
			visual_p2.scale.x = 0.15


func set_move_state(state: String) -> void:
	
	if state == move_state:
		return
	move_state = state
	if state == "idle":
		front.play("idle")
		back.play("idle")
		if not mid_is_biting:
			mid.play("idle")
		if anim_player.current_animation != "RESET":
			anim_player.play("RESET")
	elif state == "run":
		front.play("run")
		back.play("run")
		if not mid_is_biting:
			mid.play("run")
		if anim_player.current_animation != "run_motion":
			anim_player.play("run_motion")


func play_bite() -> void:
	mid_is_biting = true
	mid.stop()
	mid.frame = 0
	mid.play("bite")
	sfx_bite.play()


func _on_mid_animation_finished() -> void:
	if mid.animation == "bite":
		mid_is_biting = false
		if move_state == "run":
			mid.play("run")
		else:
			mid.play("idle")


func _clamp_pos_to_screen() -> void:
	var screen_rect = Utils.get_global_viewport_rect()
	var sprite_rect = Utils.get_sprite_global_rect(sprite)
	global_position = global_position.clamp(
		screen_rect.position + sprite_rect.size / 2,
		screen_rect.end - sprite_rect.size / 2
	)


func is_biting() -> bool:
	return Utils.is_player_action_just_pressed("button1", player)
