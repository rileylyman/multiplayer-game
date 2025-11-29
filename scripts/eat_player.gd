extends RigidBody2D

@export var player: Utils.PlayerType = Utils.PlayerType.PLAYER_1
@export var radius := 200.0

@onready var start_point := global_position
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
    var move = Utils.get_player_move_vector("move_left", "move_right", "move_up", "move_down", player)

    apply_central_force(move * 3000)

    var to_start = start_point - global_position
    apply_central_force(to_start * 10)

    _clamp_pos_to_screen()


func _clamp_pos_to_screen() -> void:
    var screen_rect = Utils.get_global_viewport_rect()
    var sprite_rect = Utils.get_sprite_global_rect(sprite)
    global_position = global_position.clamp(screen_rect.position + sprite_rect.size / 2, screen_rect.end - sprite_rect.size / 2)
