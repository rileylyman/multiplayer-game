class_name Chainsaw extends Area2D

@onready var sprite_container: Node2D = $SpriteContainer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _sprite_height := 60.0
@onready var _screen_height := Utils.wssr().size.y
@onready var player1: RigidBody2D = $"/root/Node2D/TugPlayer"
@onready var player2: RigidBody2D = $"/root/Node2D/TugPlayer2"


var _curr_time_s := 0.0

func _ready() -> void:
    body_entered.connect(func(body):
        if GameManager.tug_over or (body != player1 and body != player2):
            return

        GameManager.tug_over = true
        player1.chainsaw_hit(body == player1)
        player2.chainsaw_hit(body == player2)
    )

func _process(delta: float) -> void:
    _curr_time_s += delta
    sprite_container.scale.y = _screen_height / _sprite_height * _curr_time_s / GameManager.round_length_s
    collision_shape.shape.size.y = 2.0 * _screen_height * _curr_time_s / GameManager.round_length_s

func get_front_position() -> Vector2:
    return Vector2(global_position.x, global_position.y + _sprite_height * sprite_container.scale.y)
