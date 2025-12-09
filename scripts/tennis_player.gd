class_name TennisPlayer extends CharacterBody2D

@export var player := Utils.PlayerType.PLAYER_1
@export var speed := 300.0

@onready var other_player: TennisPlayer = $"/root/SceneRoot/TennisPlayer2" if player == Utils.PlayerType.PLAYER_1 else $"/root/SceneRoot/TennisPlayer"
@onready var sprite: Sprite2D = $Sprite2D

var ball: TennisBall = null

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
    return ret.clamp(wssr.position, wssr.end)


func _physics_process(_delta: float) -> void:
    var move_vector = Utils.get_player_move_vector("move_left", "move_right", "move_up", "move_down", player)
    var desired = speed * move_vector
    velocity = velocity.lerp(desired, 0.1)
    move_and_slide()
    _clamp_pos_to_screen()

    if ball != null and ball.is_near_ground():
        if Utils.is_player_action_just_pressed("button1", player):
            ball.hit_towards(_get_hit_to_point())
            GameManager.add_score(19, player)

func _clamp_pos_to_screen() -> void:
    var screen_rect = Utils.get_global_viewport_rect()
    var sprite_rect = Utils.get_sprite_global_rect(sprite)
    global_position = global_position.clamp(screen_rect.position + sprite_rect.size / 2, screen_rect.end - sprite_rect.size / 2)
