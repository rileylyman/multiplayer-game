extends CharacterBody2D

@export var player := Utils.PlayerType.PLAYER_1
@export var speed := 300.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

@onready var player1_layer: AnimatedSprite2D = $player1
@onready var player2_layer: AnimatedSprite2D = $player2

func _ready() -> void:
    if player == Utils.PlayerType.PLAYER_1:
        player1_layer.visible = true
        player2_layer.visible = false
        player1_layer.play("idle")
    else:
        player1_layer.visible = false
        player2_layer.visible = true
        player2_layer.play("idle")

func _physics_process(_delta: float) -> void:
    var move_vector = Utils.get_player_move_vector("move_left", "move_right", "move_up", "move_down", player)
    var desired = speed * move_vector
    velocity = velocity.lerp(desired, 0.1)
    move_and_slide()
    if Utils.is_player_action_just_pressed("button1", player):
        _play_lick()
    _clamp_pos_to_screen()

    for splatter in area.get_overlapping_areas():
        if not splatter.is_in_group("splatter"):
            continue
        
        if Utils.is_player_action_just_pressed("button1", player):
            if splatter.take_damage():
                GameManager.add_score(1, player)
                
func _play_lick() -> void:
    var layer = player1_layer if player == Utils.PlayerType.PLAYER_1 else player2_layer
    layer.frame = 0

    layer.play("lick")

func _clamp_pos_to_screen() -> void:
    var screen_rect = Utils.get_global_viewport_rect()
    var sprite_rect = Utils.get_sprite_global_rect(sprite)
    global_position.x = clamp(global_position.x, screen_rect.position.x + sprite_rect.size.x / 2, screen_rect.end.x - sprite_rect.size.x / 2)
