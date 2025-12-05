class_name WhackAPlayer extends CharacterBody2D

@export var player := Utils.PlayerType.PLAYER_1
@export var speed := 300.0
@export var bite_duration := 0.5

@onready var other_player: WhackAPlayer = $"/root/WhackAMole/WhackAPlayer2" if player == Utils.PlayerType.PLAYER_1 else $"/root/WhackAMole/WhackAPlayer"
@onready var sprite: Sprite2D = $Sprite2D

var _frozen := false

func freeze() -> void:
    _frozen = true
    await get_tree().create_timer(bite_duration).timeout
    _frozen = false

func _physics_process(_delta: float) -> void:
    if _frozen:
        return
    var move_vector = Utils.get_player_move_vector("move_left", "move_right", "move_up", "move_down", player)
    var desired = speed * move_vector
    velocity = velocity.lerp(desired, 0.1)
    move_and_slide()
    _clamp_pos_to_screen()

func _clamp_pos_to_screen() -> void:
    var screen_rect = Utils.get_global_viewport_rect()
    var sprite_rect = Utils.get_sprite_global_rect(sprite)
    global_position = global_position.clamp(screen_rect.position + sprite_rect.size / 2, screen_rect.end - sprite_rect.size / 2)

func is_biting() -> bool:
    return Utils.is_player_action_just_pressed("button1", player) or Utils.is_player_action_just_pressed("button2", player)
