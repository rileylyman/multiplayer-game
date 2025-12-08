class_name TugPlayer
extends RigidBody2D

@export var rope_len := 400.0
@export var player := Utils.PlayerType.PLAYER_1
@export var move_force := 100.0
@export var other_player: TugPlayer
@export var rand_factor_max := 5.0
@export var rand_factor_min := 0.5
@export var rand_factor_period := 2
@export var spam_inc := 0.1

@onready var trophy: RigidBody2D = %Trophy
@onready var sprite: Sprite2D = $Sprite2D
@onready var _curr_rand_factor := randf_range(rand_factor_min, rand_factor_max)
@onready var _arm_container: ArmContainer = $ArmContainer
@onready var visual = $Visual

var need_back_burst := false
var tug_over := false

var _rand_factor_dir := 1
var move_state := "idle"

func _ready() -> void:
	_periodic_random_impulse()
	visual.play_state("idle")

func _periodic_random_impulse() -> void:
	while not tug_over:
		var impulse = 0.25 * move_force * Vector2(randf_range(-1, 1), randf_range(-1, 1))
		apply_central_impulse(impulse)
		await get_tree().create_timer(randf_range(2.0, 3.0)).timeout

func chainsaw_hit(is_self: bool) -> void:
	if tug_over:
		return
	tug_over = true
	need_back_burst = is_self
	_arm_container.player_hit(is_self)
	if is_self:
		move_state = "jump"
		visual.play_state("jump")

func _process(delta: float) -> void:
	_curr_rand_factor += _rand_factor_dir * delta * (rand_factor_max - rand_factor_min) / rand_factor_period
	if _curr_rand_factor > rand_factor_max or _curr_rand_factor < rand_factor_min:
		_rand_factor_dir *= -1

	if not tug_over:
		_arm_container.target = other_player.global_position

func _physics_process(_delta: float) -> void:
	var move_vector = _get_move_vector(player)
	apply_central_force(move_vector * move_force)

	if Utils.is_player_action_just_pressed("button1", player):
		var d = move_vector
		if d.length() == 0:
			d = -_get_trophy_vector().normalized()
		apply_central_impulse(d * move_force * 0.25)

	if need_back_burst:
		apply_central_impulse((Vector2.LEFT if player == Utils.PlayerType.PLAYER_1 else Vector2.RIGHT) * move_force * 2)
		need_back_burst = false

	_clamp_pos_to_screen()

	var to_other = other_player.global_position - global_position
	if not tug_over and to_other.length() > rope_len:
		var force = -to_other.normalized() * move_force
		force *= 0.25 * (to_other.length() - rope_len)
		force *= _curr_rand_factor
		other_player.apply_central_force(force)

	var new_state = move_state
	if not tug_over:
		if move_vector.length() > 0.1:
			new_state = "run"
		else:
			new_state = "idle"

	if new_state != move_state:
		move_state = new_state
		visual.play_state(move_state)

func _clamp_pos_to_screen() -> void:
	var screen_rect = Utils.get_global_viewport_rect()
	var sprite_rect = Utils.get_sprite_global_rect(sprite)
	global_position = global_position.clamp(screen_rect.position + sprite_rect.size / 2, screen_rect.end - sprite_rect.size / 2)

func _get_trophy_vector() -> Vector2:
	return trophy.global_position - global_position

func _get_move_vector(player_type: Utils.PlayerType) -> Vector2:
	return Utils.get_player_move_vector("move_left", "move_right", "move_up", "move_down", player_type)
